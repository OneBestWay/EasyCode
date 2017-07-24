//: [Previous](@previous)

/*:
 
 viewWillAppear:(BOOL)animated
 当view将要被添加到view hierarchy时调用,此时设备已经准备好展示UIView实例了
 
 
 * 放一些不花费时间的代码在这个方法里
 * 改变status bar的状态以适应view
 * 当view可见时隐藏或disable actions
 
 viewDidAppear:(BOOL)animated
 通知view controller被添加到window上
 可以添加一些花费比较昂贵的操作
 
 viewWillDisappear:(BOOL)animated
 当view被从view hierarchy上移除时调用
 
 * 保存对view做的一些编辑和改变
 * 此时view还是first responder
 
 viewDidAppear:(BOOL)animated
 view已经被成功的从view hierarchy上移除
 
 
 View Controller
 
 * Content view Controller
 * Container view controller
 
 从storyboard中加载view controller ,归档文件会被加载到内存中处理，自动调用initWithCode来处理
 
 从nib文件中去加载view controller
 
 */

//: [Next](@next)
