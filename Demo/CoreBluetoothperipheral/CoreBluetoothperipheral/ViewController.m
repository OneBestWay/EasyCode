//
//  ViewController.m
//  CoreBluetoothperipheral
//
//  Created by GK on 2017/6/30.
//  Copyright © 2017年 GK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CBPeripheralManagerDelegate>
@property (nonatomic,strong) CBPeripheralManager *peripheralManager;
@property (nonatomic,strong) CBMutableCharacteristic *characteristic;
@property (nonatomic,strong) CBMutableService *service;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    //创建characteristic
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:@"EA0D33BD-34AB-488B-A1EF-918BDD0D3DC8"];
    NSData *data = [[NSData alloc] init];
    self.characteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID properties:CBCharacteristicPropertyRead value:data permissions:CBAttributePermissionsReadable];
    //创建service
    CBUUID *serviceUUID = [CBUUID UUIDWithString:@""];
    self.service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
    
    self.service.characteristics = @[self.characteristic];
    
    //3: 会回调peripheralManager:didAddService:error:
    [self.peripheralManager addService:self.service];
    
    // 4 广播service
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : self.service.UUID}];
}


//2: 判断当前iOS设备是否可以作为peripheral
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
}
//3: 添加service时回调
-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    
}

//4:开始广播时回调
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    
}

//5; 当受到读请求时，会回调改方法， 该回调将请求封装为了 CBATTRequest 对象，在该对象中，包含很多可用的属性。
// 可以通过 CBATTRequest 的 characteristic 属性来判断当前被读的 characteristic 是哪一个 characteristic
-(void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    
    //确定唯一的characteristic
    if ([request.characteristic.UUID isEqual:self.characteristic.UUID]) {
        // 确保读取数据的 offset（偏移量）不会超过 characteristic 数据的总长度
        if (request.offset > self.characteristic.value.length) {
            
            // 假设偏移量验证通过，下面需要截取 characteristic 中的数据，并赋值给 request.value。注意，offset 也要参与计算
            request.value = [self.characteristic.value subdataWithRange:NSMakeRange(request.offset, self.characteristic.value.length - request.offset)];
            // 读取完成后，记着调用 CBPeripheralManager 的 respondToRequest:withResult: 方法，告诉 central 已经读取成功了：
            // 如果 UUID 匹配不上，或者是因为其他原因导致读取失败，那么也应该调用 respondToRequest:withResult: 方法，并返回失败原因
            [self.peripheralManager respondToRequest:request withResult:CBATTErrorInvalidOffset];
            return;
        }
    }
    
    
}

// 6:当收到写请求时，回调改方法
// 该方法会获得一个 CBATTRequest 数组，包含所有写入请求
// 当确保一切验证没问题后（与读取操作验证类似：UUID 与 offset），便可以进行写入
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    
    //写入数据
    self.characteristic.value = requests[0].value;
    //成功后，同样去调用 respondToRequest:withResult:。但是和读取操作不同的是，读取只有一个 CBATTRequest，
    // 但是写入是一个 CBATTRequest 数组，所以这里直接传入第一个 request 就行：
    [self.peripheralManager respondToRequest:[requests objectAtIndex:0] withResult:CBATTErrorSuccess];
}

//7; central 订阅characteristic，回调改方法
// 通过上面这个代理，可以用个数组来保存被订阅的 characteristic，并在它们的数据更新时，调用 CBPeripheralManager 的 updateValue:forCharacteristic:onSubscribedCentrals: 方法来告诉 central  有新的数据：

-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
   // NSData *updatedValue = // fetch the characteristic's new value
    
    //这个方法的最后一个参数能指定要通知的 central。如果参数为 nil，则表示想所有订阅了的 central 发送通知。
    //同时，updateValue:forCharacteristic:onSubscribedCentrals: 方法会返回一个 BOOL 标识是否发送成功。如果发送队列任务是满的，则会返回 NO。当有可用的空间时，会回调 peripheralManagerIsReadyToUpdateSubscribers: 方法。所以你可以在这个回调用调用 updateValue:forCharacteristic:onSubscribedCentrals: 重新发送数据
    //发送数据使用到的是通知，当你更新订阅的 central 时，应该调用一次 updateValue:forCharacteristic:onSubscribedCentrals:
   // BOOL didSendValue = [myPeripheralManager updateValue:updatedValue forCharacteristic:characteristic onSubscribedCentrals:nil];
}
@end

// 作为peripheral 需要自己创建树形结构
// service和characteristis  根据UUID来区分的，创建自己的UUID用uuidgen
// 创建CBMutableService 和 CBMutableCharacteristic 来创建树形结构
// 如果给 characteristic 设置了 value 参数，那么这个 value 会被缓存，并且 properties 和 permissions 会自动设置为可读。如果想要 characteristic 可写，或者在其生命周期会改变它的值，那需要将 value 设置为 nil。这样的话，就会动态的来处理 value

// self.service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES]
//第二个参数 primary 设置为 YES 表示该 service 为 primary service（主服务），与 secondary service（次服务）相对。primary service 描述了设备的主要功能，并且能包含其他 service。secondary service 描述的是引用它的那个 service 的相关信息。比如，一个心率监测器，primary service 描述的是当前心率数据，secondary service 描述描述的是当前电量。
// 构建好树形结构之后，接下来便需要将这结构加入设备的数据库 Core Bluetooth 已经封装好了，调用 CBPeripheralManager 的 addService: 方法即可

//当调用add Service 的方法时会回调 CBPeripheralDelegate 的 peripheralManager:didAddService:error:

// 当你发布 service 之后，service 就会缓存下来，并且无法再修改。

//搞定发布 service 和 characteristic 之后，就可以开始给正在监听的 central 发广播了

//通过调用 CBPeripheralManager 的 startAdvertising: 方法并传入字典作为参数来进行广播

// key 只用到了 CBAdvertisementDataServiceUUIDsKey，对应的 value 是包含需要广播的 service 的 CBUUID 类型数组

//只有 CBAdvertisementDataLocalNameKey 和 CBAdvertisementDataServiceUUIDsKey 才是 peripheral Manager

//当开始广播时，peripheral Manager 会回调 peripheralManagerDidStartAdvertising:error: 方法

//广播服务在程序挂起时依然可用，详细会在之后讲到。

//在连接到一个或多个 central 之后，peripheral 有可能会收到读写请求

//当收到读请求时，会回调 peripheralManager:didReceiveReadRequest: 方法

//当收到写请求时，CBPeripheralManager 回调 peripheralManager:didReceiveWriteRequests:

//发送更新数据给订阅了的 central  central 可能会订阅了一个或多个 characteristic，当数据更新时，需要给他们发送通知。下面就来详细介绍下
//central 订阅 characteristic 的时候会回调 CBPeripheralManager 的 peripheralManager:central:didSubscribeToCharacteristic: 方法

// 即使广播可以包含 peripheral 的很多信息，但是其实只需要广播 peripheral 的名称和 service 的 UUID 就足够了。也就是构建字典时，填写 CBAdvertisementDataLocalNameKey 和 CBAdvertisementDataServiceUUIDsKey 对应的 value 即可，如果使用其他 key，将会导致错误。

// 当 app 运行在前台时，有 28 bytes 的空间可用于广播。如果这 28 bytes 用完了，则会在扫描响应时额外分配 10 bytes 的空间，但这空间只能用于被 CBAdvertisementDataLocalNameKey 修饰的 local name（即在 startAdvertising: 时传入的数据）。以上提到的空间，均不包含 2 bytes 的报文头。被 CBAdvertisementDataServiceUUIDsKey 修饰的 service 的 UUID 数组数据，均不会添加到特殊的 overflow 区域。并且这些 service 只能被 iOS 设备发现。当程序挂起后，local name 和 UUID 都会被加入到 overflow 区

// 只广播必要的数据
// 当 peripheral 想要被发现时，它会向外界发送广播，此时会用到设备的无线电（当然还有电池）。一旦连接成功，central 便能直接从 peripheral 中读取数据了，那么此时广播的数据将不再有用。所以，为了减少无线电的使用、提高手机性能、保护设备电池，应该在被连接后，及时关闭广播。停止广播调用 CBPeripheralManager 的 stopAdvertising 方法即可

//手动开启广播

//其实什么时候应该广播，多数情况下，用户比我们更清楚。比如，他们知道周围没有开着的 BLE 设备，那他就不会把 peripheral 的广播打开。所以提供给用户一个手动开启广播的 UI 更为合适。

//配置 characteristic

//在创建 characteristic 的时候，就为它设定了相应的 properties、value 和 promissions。这些属性决定了 central 如何和 characteristic 通信。properties 和 promissions 可能需要根据 app 的需求来设置，下来就来谈谈如何配置 characteristic：

//允许 central 订阅 characteristic。
//防止未配对的 central 访问 characteristic 的敏感信息。

//让 characteristic 支持通知
//之前在 central 的时候提到过，如果要读取经常变化的 characteristic 的数据，更推荐使用订阅。所以，如果可以，最好 characteristic 允许订阅。

//如果像下面这样初始化 characteristic 就是允许读和订阅

//myCharacteristic = [[CBMutableCharacteristic alloc]
//initWithType:myCharacteristicUUID
//properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify
//value:nil permissions:CBAttributePermissionsReadable];


//限制只能配对的 central 才能访问敏感信息

//有些时候，可能有这样的需求：需要 service 的一个或多个 characteristic 的数据安全性。假如有一个社交媒体的 service，那么它的 characteristic 可能包含了用户的姓名、邮箱等私人信息，所以只让信任的 central 才能访问这些数据是很有必要的。

//这可以通过设置相应的 properties 和 promissions 来达到效果：
// emailCharacteristic = [[CBMutableCharacteristic alloc]
//initWithType:emailCharacteristicUUID
//properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotifyEncryptionRequired
//value:nil permissions:CBAttributePermissionsReadEncryptionRequired];

//向上面这样设置，便能只让配对的 central 才能进行订阅。并且在连接过程中，Core Bluetooth 还会自动建立安全连接。

//在尝试配对时，两端都会弹出警告框，central 端会提供 code，peripheral 端必须要输入该 code 才能配对成功。成功之后，peripheral 才会信任该 central，并允许读写数据。
