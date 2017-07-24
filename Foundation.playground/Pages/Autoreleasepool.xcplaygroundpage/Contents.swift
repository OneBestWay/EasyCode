//: [Previous](@previous)

/*:
 Autoreleasepool
 
 系统在每个runloop的迭代中都加入了自动释放池push和pop,autorelease对象在runloop迭代结束时释放
 自动释放池中的对象在每次runloop迭代中自动释放

 
 创建一个新线程时需要立马创建一个autoreleasepool否则会造成内存泄露
 
 循环中创建了大量的临时对象，需要创建autoreleasepool
 
 
 
 每个线程都有一个autoreleasepool栈，当一个新的autoreleasepool被创建时，就会被push进栈，当池子被释放时就会pop出站，调用autorelease的对象会自动放在栈顶的池子中，当线程结束的时候，会自动释放掉与改线程所有有关的池子
 */
//: [Next](@next)
