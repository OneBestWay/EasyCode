//: [Previous](@previous)

/*:
 # link
 [runloop3](https://github.com/ChenYilong/iOSInterviewQuestions/blob/master/01%E3%80%8A%E6%8B%9B%E8%81%98%E4%B8%80%E4%B8%AA%E9%9D%A0%E8%B0%B1%E7%9A%84iOS%E3%80%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%82%E8%80%83%E7%AD%94%E6%A1%88/%E3%80%8A%E6%8B%9B%E8%81%98%E4%B8%80%E4%B8%AA%E9%9D%A0%E8%B0%B1%E7%9A%84iOS%E3%80%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%82%E8%80%83%E7%AD%94%E6%A1%88%EF%BC%88%E4%B8%8B%EF%BC%89.md#28-runloop%E5%92%8C%E7%BA%BF%E7%A8%8B%E6%9C%89%E4%BB%80%E4%B9%88%E5%85%B3%E7%B3%BB)
 [runloop](http://blog.ibireme.com/2015/05/18/runloop/)
 [runloop2](http://blog.ibireme.com/2015/05/18/runloop/#base)
 # NSThread
  * 一个线程只能执行一个任务，执行完后线程就会退出
  * 为了让线程不退出，随时处理事件，用到runloop
 
 Runloop是一个对象，这个对象提供了管理输入资源的接口，输入的资源包括键盘，鼠标事件，NSport,NSconnection,NStimier
 
 iOS中由两个对象： NSRunloop, CFRunLoopRef
 CFRunLoopREF属于CoreFoundation框架内的，纯CAPI，是线程安全的
 NSRunLoop是面向对象的对CFRunLoopRef的封装，不是线程安全的
 
 * 线程和RunLoop是一一对应的
 * 线程刚创建时没有RunLoop,只有主动获取，才会去创建runLoop
 * runLoop的创建是在第一次获取时，销毁是在线程销毁结束时
 * 只能在一个线程内部获取其runloop,但可以在任何线程内获取主runloop
 
 
 一个runLopp包含如干个Mode,每个mode包含若干个source,timer,observer
 
 主线程有两个预置的mode,kCFRunLoopDefaultMode 和 UITrackingRunLoopMode
 
 CADisplayLink是和屏幕刷新频率一致的定时器 facebook的AsyncDisplayLink
 
 PerfornSelecter  实际上创建了一个定时器，并添加到当前线程的runloop中，如果当前线程没runloop，该方法会失败
 
 NSURLConnection的start 函数获取当前线程的runloop,并向其中的defaultmode添加4个source0,
 
 当网络开始传输的时候，NSURLConnection创建了两个线程，com.apple.NSURLConnectionLoader和com.apple.CFSocket.private
 
 CFSocket线程负责和底层Socket通信，ConnectionLoader线程使用runloop来接收socket的事件，并通过source0来通知到上层的delegate
 
 Runloop通过基于mach port的source来接收底层CFSocket的通知，当收到通知后，会在合适的时机向source0发送通知，同时唤醒Delegate线程的RunLoop来让其处理这些通知
 
 CFMultiplexerSource会在Delegate线程的runloop对Delegate执行实际的回调
 
 
 AsyncDisplaykit是Facebook推出保持界面流畅性的框架
 
 尽量将能放在后台的操作放在后台执行，不能放在后台的操作延迟执行
 
 ASDisplayNode封装了UIView、Calayer,通过Node来操作内部的UIView,但无论如何，这些属性都必须同步到主线程
 
 */
