 //: [Previous](@previous)

/*:
  * RunTime是OC面向对象和动态机制的基石
  * 动态语言意味着不仅需要一个编译器也需要一个运行时系统来动态的创建类和对象，进行消息的传递和转发
  * msg_send,在objective-c中，class,object,method都是一个C的结构体
  
  msgSend方法做了什么
  * 通过obj的isa指针找到他的class
  * 在class的objc_cache中找foo,如果没找到，在class的 method list中找foo
  * 如果class中没找到foo,继续往他的superclass中找
  * 一旦找到foo这个函数，就去执行他的IMP
  
  通常情况下，如果没有找到方法，OC会给你三次拯救程序的机会
  
  * 运行时首先会去调用resolveInstanceMethod 或resolveClassMethod方法，在这个方法里面去提供一个函数的实现
  如果添加了函数的实现并返回YES,那么运行时系统就会重新启动一次消息发送的过程
  
        void fooMethod(id obj, SEL _cmd)
        {
            NSLog(@"Doing foo");
        }

        + (BOOL)resolveInstanceMethod:(SEL)aSEL
        {
            if(aSEL == @selector(foo:)){
                class_addMethod([self class], aSEL, (IMP)fooMethod, "v@:");
                return YES;
            }
            return [super resolveInstanceMethod];
        }
  
  * 如果resolve方法返回No,运行时调用forwardingTargetForSelector，可以把消息转发给其他对象
          - (id)forwardingTargetForSelector:(SEL)aSelector
          {
              if(aSelector == @selector(foo:)){
                  return alternateObject;
              }
              return [super forwardingTargetForSelector:aSelector];
          }
  只要这个方法返回的不是nil和self,整个消息发送机制就会重启
  
  * 如果返回nil或self,runtime会调用forwardInvocation方法，把整个消息打包创建一个NSInvocation对象，转发给其他对象
      - (void)forwardInvocation:(NSInvocation *)invocation
      {
          SEL sel = invocation.selector;
          
          if([alternateObject respondsToSelector:sel]) {
              [invocation invokeWithTarget:alternateObject];
          }
          else {
              [self doesNotRecognizeSelector:sel];
          }
      }
http://www.jianshu.com/p/6df75d8831e4
//: [Next](@next)
  
*/
