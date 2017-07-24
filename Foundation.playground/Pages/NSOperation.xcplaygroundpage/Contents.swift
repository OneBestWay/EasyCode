//: [Previous](@previous)

/*:
 
   [NSHipster_Operation](http://nshipster.cn/nsoperation/)
 
 # NSThread
   pThread  , NSthread  , NSoperation and NSOperationQueue
   process  一个进程能保持多个线程，每一个线程能够同时执行多个任务
 
   NSOperation 和 Grand Central Dispatch
   
   NSOperation和NSOperationQueue构建在GCD之上
   
   GCD: 添加依赖，取消任务比较难
   
   NSOperation是一个抽象类，必须继承，继承之后覆盖main方法
   让一个NSOperation操作开始，直接调用start,或者直接添加到NSOperationQueue
 
   NSOperationQueue只有当它管理的所有Operation被isFinished标记为YES时，队列停止运行
 
 */
//: [Next](@next)
