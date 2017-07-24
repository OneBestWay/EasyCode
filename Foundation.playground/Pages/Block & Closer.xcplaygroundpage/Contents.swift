//: [Previous](@previous)

/*: 
 
 [Block介绍](https://www.appcoda.com/objective-c-blocks-tutorial/)
 [Block高级使用](https://www.wangjiawen.com/ios/ios-block-usage-and-implementation)
 那些地方用到Block
 *  呈现view controller,呈现完后想要做一些事情
 *  UIView 执行完动画后
 *  GCD中使用
 *  Block作为函数的参数
 *  Block可截获所使用的自动变量的值，截获的意思是保存自动变量的瞬间值
 *  Block不能更改其所截获的自动变量的值，如需要更改用__Block声明
 *  如果是类对象，在block内部可以更改类对象的属性
 *  如果是可变对象，如可变数组，在blcok内部可以对其增删
 
 
     NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"1", @"2",nil ];
     NSLog(@"Array Count:%ld", array.count);//打印Array Count:2
     void (^blk)(void) = ^{
     [array removeObjectAtIndex:0];//Ok
     //array = [NSNSMutableArray new];//没有__block修饰，编译失败！
     };
     blk();
     NSLog(@"Array Count:%ld", array.count);//打印Array Count:1
 
 * 全局Block存储在全局数据区，截获了自动变量的block,放在栈上
 * 没有截获自动变量的block，放在全局数据区
 * 栈上的block,启所属的栈作用域结束，block失效，如果想要block继续使用，block会自动复制到堆上
 * 自动赋值栈上的block到堆上
   调用Block的copy 方法
   block作为返回值
   block赋值给———— Strong修改的变量
   useBlock或GCD的API传递block
 * __block修饰的变量，封装为一个结构体，让其在堆上创建，以方便从堆上或栈上修改同一份数据
 * 将block内部要哦使用的变量以参数的形式传递，block不会捕获改对象，block参数的生命周期由栈自动管理，不会造成内存泄露
 打破循环应用的三种方式
 *  用weak
 * 用 __Block修饰，在block内部使用完后，置为nil
 * 对象作为block的参数传进block
 
 
 */

//: [Next](@next)
