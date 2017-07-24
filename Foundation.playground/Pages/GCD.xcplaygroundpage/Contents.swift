//: [Previous](@previous)

/*:
 # What is GCD
 
 [GCD1](https://www.raywenderlich.com/63338/grand-central-dispatch-in-depth-part-2)
 GCD是libdispatch的别名，
 
 * GCD能够提升app的反应速度，把计算昂贵的工作在background执行
 * GCD提供非常容易的并发模型，相比lock和thread来说会减少许多bug
 * GCD可以使代码具有更高的性能
 
 # 线程池 [](http://www.tuicool.com/articles/3Q3Uzqf)
 
   提交到全局队列中的Block,全局队列底层有一个线程池，会被线程池中的线程来执行，如果线程池已满，后续提交到Block就不会重新创建线程，如果block越来越多，就有可能使app crash
    因为存在上面的问题，所以不要用GCD全局队列来创建常驻线程
 
 
 serial:  串行，在一个时间只执行一个任务
 concurrent: 并行，在相同的时间执行多个任务
 
 Synchronous: 同步 在任务完成之后返回，会阻塞当前线程
 Asynchronous: 异步 立即返回，不会阻塞当前线程
 
 GCD:
 dispatch queue来掌控block,遵循先进先出的原则
 dispatch queue是线程安全的，可以从多个线程同时获取dispatch queue
 
 两种DispatchQueue
 * Serial queues 某一时间只执行一个任务，任务在他前面的任务完成之后才能开始，某个时间只执行一个任务，按照添加到queue中的顺序来依次执行任务
 * Concurrent Queues tasks按照添加的顺序开始执行
 
 系统提供一个特殊的serial queue， main queue,主队列是唯一的一个发送信息给UIView,和post notification的对列，所有更新UI的操作都应该在主线程执行
 系统也提供了几个concurrent quques，global quques,根据优先级的不同，分为四个
 
 * background
 * low
 * default
 * high
 
 可以创建自己的Serial 和 concurrent queues
 
 dispatch_after  延迟执行，建议在主线程执行
 dispatch_once 生成单例
 dispatc barriers 解决读写问题,建议用在Custom Concurrent Queue上， 用dispatch barriers 能够确保某个queue上某一时间只有一个Block在执行
 那也意味着该queue上在dispatch barrier的block之前的block都执行完了，GCD提供同步和异步的barries
 
  ![print_pre](Dispatch-Barrier.png)
 
 用dispatch barrier 来解决读写问题
 
     - (void)addPhoto:(Photo *)photo
       {
          if (photo) { // 1
              dispatch_barrier_async(self.concurrentPhotoQueue, ^{ // 2
              [_photosArray addObject:photo]; // 3
              dispatch_async(dispatch_get_main_queue(), ^{ // 4
                 [self postContentAddedNotification];
              });
           });
          }
        }
 
 Concurrent queue 用dispatch sync
 
     - (NSArray *)photos
    {
       __block NSArray *array; // 1
       dispatch_sync(self.concurrentPhotoQueue, ^{ // 2
           array = [NSArray arrayWithArray:_photosArray]; // 3
       });
       return array;
     }
 
 
 Dispatch_Group :当整个组的任务都完成之后，得到通知
 
 当添加到Group中的所有任务完成之后，由两种方式得到通知
 * dispatch_group_wait  阻止当前的线程，直至Group中的所有的任务都完成或者超时
 
 * dispatch_group可以用在Custom serial Queue,main quque,Concurrent Queue
 
         - (void)downloadPhotosWithCompletionBlock:(BatchPhotoDownloadingCompletionBlock)completionBlock
          {
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1

               __block NSError *error;
               dispatch_group_t downloadGroup = dispatch_group_create(); // 2

               for (NSInteger i = 0; i < 3; i++) {
                   NSURL *url;
                   switch (i) {
                     case 0:
                       url = [NSURL URLWithString:kOverlyAttachedGirlfriendURLString];
                       break;
                     case 1:
                       url = [NSURL URLWithString:kSuccessKidURLString];
                       break;
                     case 2:
                       url = [NSURL URLWithString:kLotsOfFacesURLString];
                       break;
                     default:
                    break;
                   }

                dispatch_group_enter(downloadGroup); // 3
                Photo *photo = [[Photo alloc] initwithURL:url
                withCompletionBlock:^(UIImage *image, NSError *_error) {
                    if (_error) {
                       error = _error;
                    }
                    dispatch_group_leave(downloadGroup); // 4
                 }];

                 [[PhotoManager sharedManager] addPhoto:photo];
               }
               dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER); // 5
                dispatch_async(dispatch_get_main_queue(), ^{ // 6
               if (completionBlock) { // 7
                    completionBlock(error);
                }
              });
            });
            }
 * 用dispatch_group_notify来异步通知
      dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{ // 4
           if (completionBlock) {
               completionBlock(error);
            }
       });
 
 
 dispatch_apply:  像一个for loop,并行的迭代，是一个同步函数，当所有的迭代完成之后，该函数返回
 
 可以用在Custom Serial Queue,main Queue, Concurrent Queue
 
 
 Semaphores : 控制多个消费者获取有限的资源
 
     - (void)downloadImageURLWithString:(NSString *)URLString
     {
         // 1
         dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
         
         NSURL *url = [NSURL URLWithString:URLString];
         __unused Photo *photo = [[Photo alloc]
         initwithURL:url
         withCompletionBlock:^(UIImage *image, NSError *error) {
             if (error) {
             XCTFail(@"%@ failed. %@", URLString, error);
             }
         
             // 2
             dispatch_semaphore_signal(semaphore);
         }];
             
             // 3
             dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, kDefaultTimeoutLengthInNanoSeconds);
             if (dispatch_semaphore_wait(semaphore, timeoutTime)) {
                 XCTFail(@"%@ timed out", URLString);
             }
     }
 */

//: [Next](@next)
