//: Playground - noun: a place where people can play

/*:
  在未来的某一时刻，执行一次或周期性的执行多次指定的方法
 # Links
 
 [nstimier-in-swift](https://www.weheartswift.com/nstimer-in-swift/)
 
 # Note
  * timier在哪个线程被触发，必须在哪个线程调用invalidate,将定时器从runloop中移出来
  * timier会对他的target进行retain
  * runloop会对添加到它里面的timer进行强引用
  * timer在一个周期内智慧触发一次
  * timier并不是实时的，会存在延迟，延迟的程度与当前执行的线程有关
  
  * timier是一种source,source要起作用，必须添加到runloop中
  * 如果某个runloop中没有了source,那么runloop会立即退出
 # Timer没有运行的可能原因
  * 没有添加到runloop中
  * 所在的runloop没有运行
  * 所在的runloopmode没有运行
 
 
 #相关
 延迟执行的三种方法：  NSObject 的performSelector:withObject:afterDelay
 NStimier: 在未来的某一断时间执行某个方法
 GCD: dispatchafter
 CADisplayLink:也可用作定时器，启调用间隔与屏幕刷新频率一致，每秒60次，如果在两次间隔之间执行了比较耗时的任务，将会造成界面卡顿
 NSTimier和NSObject  都是基于runloop的，NSTimer的创建和销毁必须在同一线程，performselector的创建喝撤销必须在同一线程
 
 performSelector:withObject:afterDelay的本质是在当前线程的runloop里去创建一个timer
 
 dispatchAfter系统会处理线程级的问题，不用关心runloop的问题
 dispatchAfter一旦执行，就不能被撤销
 
 而performSelector可以使用cancelPreviousPerformRequestsWithTarget方法撤销
 NSTimer也可以调用invalidate进行撤销
 #用GCD实现一个timer
 [ss](GCDTimier.png)
 
 */
