//: [Previous](@previous)

/*:
 
 # 谈谈 iOS 中图片的解压缩

 对于大多数 iOS 应用来说，图片往往是最占用手机内存的资源之一，同时也是不可或缺的组成部分。将一张图片从磁盘中加载出来，并最终显示到屏幕上，中间其实经过了一系列复杂的处理过程，其中就包括了对图片的解压缩。
 
 ## 图片加载的工作流
 
 概括来说，从磁盘中加载一张图片，并将它显示到屏幕上，中间的主要工作流如下：
 
 1. 假设我们使用 +imageWithContentsOfFile: 方法从磁盘中加载一张图片，这个时候的图片并没有解压缩；
 2. 然后将生成的 UIImage 赋值给 UIImageView ；
 3. 接着一个隐式的 CATransaction 捕获到了 UIImageView 图层树的变化；
 4. 在主线程的下一个 run loop 到来时，Core Animation 提交了这个隐式的 transaction ，这个过程可能会对图片进行 copy 操作，而受图片是否字节对齐等因素的影响，这个 copy 操作可能会涉及以下部分或全部步骤：
 
     a. 分配内存缓冲区用于管理文件 IO 和解压缩操作；
 
     b. 将文件数据从磁盘读到内存中；
 
     c. 将压缩的图片数据解码成未压缩的位图形式，这是一个非常耗时的 CPU 操作；
 
     d. 最后 Core Animation 使用未压缩的位图数据渲染 UIImageView 的图层。
 
 在上面的步骤中，我们提到了图片的解压缩是一个非常耗时的 CPU 操作，并且它默认是在主线程中执行的。那么当需要加载的图片比较多时，就会对我们应用的响应性造成严重的影响，尤其是在快速滑动的列表上，这个问题会表现得更加突出。
 
 ## 为什么需要解压缩
 
 既然图片的解压缩需要消耗大量的 CPU 时间，那么我们为什么还要对图片进行解压缩呢？是否可以不经过解压缩，而直接将图片显示到屏幕上呢？答案是否定的。要想弄明白这个问题，我们首先需要知道什么是位图：
 
 A bitmap image (or sampled image) is an array of pixels (or samples). Each pixel represents a single point in the image. JPEG, TIFF, and PNG graphics files are examples of bitmap images.
 
 其实，位图就是一个像素数组，数组中的每个像素就代表着图片中的一个点。我们在应用中经常用到的 JPEG 和 PNG 图片就是位图。下面，我们来看一个具体的例子，这是一张 PNG 图片，像素为 30 × 30 ，文件大小为 843B ：
 
 位图
 
 我们使用下面的代码：
 
 ![print_pre](/ImageCompression/1.png)
 
 就可以获取到这个图片的原始像素数据，大小为 3600B ：
 
 ![print_pre](/ImageCompression/2.png)
 
 
  也就是说，这张文件大小为 843B 的 PNG 图片解压缩后的大小是 3600B ，是原始文件大小的 4.27 倍。那么这个 3600B 是怎么得来的呢？与图片的文件大小或者像素有什么必然的联系吗？事实上，解压缩后的图片大小与原始文件大小之间没有任何关系，而只与图片的像素有关：
 
 1
 解压缩后的图片大小 = 图片的像素宽 30 * 图片的像素高 30 * 每个像素所占的字节数 4
 至于这个公式是怎么得来的，我们后面会有详细的说明，现在只需要知道即可。
 
 至此，我们已经知道了什么是位图，并且直观地看到了它的原始像素数据，那么它与我们经常提到的图片的二进制数据有什么联系吗？是同一个东西吗？事实上，这二者是完全独立的两个东西，它们之间没有必然的联系。为了加深理解，我把这个图片拖进 Sublime Text 2 中，得到了这个图片的二进制数据，大小与原始文件大小一致，为 843B ：
 
 ![print_pre](/ImageCompression/3.png)

 事实上，不管是 JPEG 还是 PNG 图片，都是一种压缩的位图图形格式。只不过 PNG 图片是无损压缩，并且支持 alpha 通道，而 JPEG 图片则是有损压缩，可以指定 0-100% 的压缩比。值得一提的是，在苹果的 SDK 中专门提供了两个函数用来生成 PNG 和 JPEG 图片：
 
 ![print_pre](/ImageCompression/4.png)
 
 因此，在将磁盘中的图片渲染到屏幕之前，必须先要得到图片的原始像素数据，才能执行后续的绘制操作，这就是为什么需要对图片解压缩的原因。
 
 ## 强制解压缩的原理
 
 既然图片的解压缩不可避免，而我们也不想让它在主线程执行，影响我们应用的响应性，那么是否有比较好的解决方案呢？答案是肯定的。
 
 我们前面已经提到了，当未解压缩的图片将要渲染到屏幕时，系统会在主线程对图片进行解压缩，而如果图片已经解压缩了，系统就不会再对图片进行解压缩。因此，也就有了业内的解决方案，在子线程提前对图片进行强制解压缩。
 
 而强制解压缩的原理就是对图片进行重新绘制，得到一张新的解压缩后的位图。其中，用到的最核心的函数是 CGBitmapContextCreate ：
 
 ![print_pre](/ImageCompression/5.png)

 顾名思义，这个函数用于创建一个位图上下文，用来绘制一张宽 width 像素，高 height 像素的位图。这个函数的注释比较长，参数也比较难理解，但是先别着急，我们先来了解下相关的知识，然后再回过头来理解这些参数，就会比较简单了。
 
 # Pixel Format
 
 我们前面已经提到了，位图其实就是一个像素数组，而像素格式则是用来描述每个像素的组成格式，它包括以下信息：
 
   1. Bits per component ：一个像素中每个独立的颜色分量使用的 bit 数；
 
   2. Bits per pixel ：一个像素使用的总 bit 数；
 
   3. Bytes per row ：位图中的每一行使用的字节数。
 
 有一点需要注意的是，对于位图来说，像素格式并不是随意组合的，目前只支持以下有限的 17 种特定组合：
 
 ![print_pre](/ImageCompression/6.png)

 
 从上图可知，对于 iOS 来说，只支持 8 种像素格式。其中颜色空间为 Null 的 1 种，Gray 的 2 种，RGB 的 5 种，CMYK 的 0 种。换句话说，iOS 并不支持 CMYK 的颜色空间。另外，在表格的第 2 列中，除了像素格式外，还指定了 bitmap information constant ，我们在后面会详细介绍。
 
 ## Color and Color Spaces
 
 在上面我们提到了颜色空间，那么什么是颜色空间呢？它跟颜色有什么关系呢？在 Quartz 中，一个颜色是由一组值来表示的，比如 0, 0, 1 。而颜色空间则是用来说明如何解析这些值的，离开了颜色空间，它们将变得毫无意义。比如，下面的值都表示蓝色：
 ![print_pre](/ImageCompression/7.png)

 
 
 如果不知道颜色空间，那么我们根本无法知道这些值所代表的颜色。比如 0, 0, 1 在 RGB 下代表蓝色，而在 BGR 下则代表的是红色。在 RGB 和 BGR 两种颜色空间下，绿色是相同的，而红色和蓝色则相互对调了。因此，对于同一张图片，使用 RGB 和 BGR 两种颜色空间可能会得到两种不一样的效果：
 ![print_pre](/ImageCompression/8.png)
 
 
 ## Color Spaces and Bitmap Layout
 
 我们前面已经知道了，像素格式是用来描述每个像素的组成格式的，比如每个像素使用的总 bit 数。而要想确保 Quartz 能够正确地解析这些 bit 所代表的含义，我们还需要提供位图的布局信息 CGBitmapInfo ：
 
 ![print_pre](/ImageCompression/9.png)

 它主要提供了三个方面的布局信息：
 
   1. alpha 的信息；
   2. 颜色分量是否为浮点数；
   3. 像素格式的字节顺序。
 其中，alpha 的信息由枚举值 CGImageAlphaInfo 来表示：
 
 ![print_pre](/ImageCompression/10.png)

 上面的注释其实已经比较清楚了，它同样也提供了三个方面的 alpha 信息：
 
 1. 是否包含 alpha ；
 
 2. 如果包含 alpha ，那么 alpha 信息所处的位置，在像素的最低有效位，比如 RGBA ，还是最高有效位，比如 ARGB ；
 
 3.  如果包含 alpha ，那么每个颜色分量是否已经乘以 alpha 的值，这种做法可以加速图片的渲染时间，因为它避免了渲染时的额外乘法运算。比如，对于 RGB 颜色空间，用已经乘以 alpha 的数据来渲染图片，每个像素都可以避免 3 次乘法运算，红色乘以 alpha ，绿色乘以 alpha 和蓝色乘以 alpha 。
 
 那么我们在解压缩图片的时候应该使用哪个值呢？根据 Which CGImageAlphaInfo should we use 和官方文档中对 UIGraphicsBeginImageContextWithOptions 函数的讨论：
 
 ![print_pre](/ImageCompression/11.png)
 
 我们可以知道，当图片不包含 alpha 的时候使用 kCGImageAlphaNoneSkipFirst ，否则使用 kCGImageAlphaPremultipliedFirst 。另外，这里也提到了字节顺序应该使用 32 位的主机字节顺序 kCGBitmapByteOrder32Host ，而这个值具体是什么，我们后面再讨论。
 
 至于颜色分量是否为浮点数，这个就比较简单了，直接逻辑或 kCGBitmapFloatComponents 就可以了。更详细的内容就不展开了，因为我们一般用不上这个值。
 
 接下来，我们来简单地了解下像素格式的字节顺序，它是由枚举值 CGImageByteOrderInfo 来表示的：
 
 ![print_pre](/ImageCompression/12.png)

 它主要提供了两个方面的字节顺序信息：
 
 1. 小端模式还是大端模式；
 
 2. 数据以 16 位还是 32 位为单位。
 
 对于 iPhone 来说，采用的是小端模式，但是为了保证应用的向后兼容性，我们可以使用系统提供的宏，来避免 Hardcoding ：
 
 ![print_pre](/ImageCompression/13.png)

 根据前面的讨论，我们知道字节顺序的值应该使用的是 32 位的主机字节顺序 kCGBitmapByteOrder32Host ，这样的话不管当前设备采用的是小端模式还是大端模式，字节顺序始终与其保持一致。
 
 下面，我们来看一张图，它非常形象地展示了在使用 16 或 32 位像素格式的 CMYK 和 RGB 颜色空间下，一个像素是如何被表示的：
 
 ![print_pre](/ImageCompression/14.png)

 
 我们从图中可以看出，在 32 位像素格式下，每个颜色分量使用 8 位；而在 16 位像素格式下，每个颜色分量则使用 5 位。
 
 好了，了解完这些相关知识后，我们再回过头来看看 CGBitmapContextCreate 函数中每个参数所代表的具体含义：
 
 1。 data ：如果不为 NULL ，那么它应该指向一块大小至少为 bytesPerRow * height 字节的内存；如果 为 NULL ，那么系统就会为我们自动分配和释放所需的内存，所以一般指定 NULL 即可；
 
 2. width 和 height ：位图的宽度和高度，分别赋值为图片的像素宽度和像素高度即可；
 
 3. bitsPerComponent ：像素的每个颜色分量使用的 bit 数，在 RGB 颜色空间下指定 8 即可；
 
 4. bytesPerRow ：位图的每一行使用的字节数，大小至少为 width * bytes per pixel 字节。有意思的是，当我们指定 0 时，系统不仅会为我们自动计算，而且还会进行 cache line alignment 的优化，更多信息可以查看 what is byte alignment (cache line alignment) for Core Animation? Why it matters? 和 Why is my image’s Bytes per Row more than its Bytes per Pixel times its Width? ，亲测可用；
 
 5. space ：就是我们前面提到的颜色空间，一般使用 RGB 即可；
 
 6. bitmapInfo ：就是我们前面提到的位图的布局信息。
 
 到这里，你已经掌握了强制解压缩图片需要用到的最核心的函数，点个赞。
 
 开源库的实现
 
 接下来，我们来看看在三个比较流行的开源库 YYKit 、SDWebImage 和 FLAnimatedImage 中，对图片的强制解压缩是如何实现的。
 
 首先，我们来看看 YYKit 中的相关代码，用于解压缩图片的函数 YYCGImageCreateDecodedCopy 存在于 YYImageCoder 类中，核心代码如下：
 
 ![print_pre](/ImageCompression/15.png)

  它接受一个原始的位图参数 imageRef ，最终返回一个新的解压缩后的位图 newImage ，中间主要经过了以下三个步骤：
 
 使用 CGBitmapContextCreate 函数创建一个位图上下文；
 使用 CGContextDrawImage 函数将原始位图绘制到上下文中；
 使用 CGBitmapContextCreateImage 函数创建一张新的解压缩后的位图。
 事实上，SDWebImage 和 FLAnimatedImage 中对图片的解压缩过程与上述完全一致，只是传递给 CGBitmapContextCreate 函数的部分参数存在细微的差别
 
 https://www.cocoanetics.com/2011/10/avoiding-image-decompression-sickness/
 https://developer.apple.com/library/content/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/Introduction/Introduction.html
 https://github.com/path/FastImageCache
 http://stackoverflow.com/questions/23790837/what-is-byte-alignment-cache-line-alignment-for-core-animation-why-it-matters
 
 */

//: [Next](@next)
