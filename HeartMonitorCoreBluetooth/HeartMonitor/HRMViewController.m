//
//  HRMViewController.m
//  HeartMonitor
//
//  Created by Main Account on 12/13/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//  苹果产品蓝牙附件指南
//  https://developer.apple.com/hardwaredrivers/BluetoothDesignGuidelines.pdf

#import "HRMViewController.h"

@interface HRMViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) CBPeripheral *polarHRH7MPeripheral;

@property (nonatomic, strong) IBOutlet UIImageView *heartImage;
@property (nonatomic,strong) IBOutlet UITextView *deviceInfo;

// Properties to hold data characteristics for the peripheral device
@property (nonatomic, strong) NSString   *connected;
@property (nonatomic, strong) NSString   *bodyData;
@property (nonatomic, strong) NSString   *manufacturer;
@property (nonatomic, strong) NSString   *polarH7DeviceData;

@property (assign) uint16_t heartRate;

// Properties to handle storing the BPM and heart beat
@property (nonatomic, strong) UILabel    *heartRateBPM;
@property (nonatomic, retain) NSTimer    *pulseTimer;


@end

@implementation HRMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray *services = @[[CBUUID UUIDWithString:POLARH7_HRM_DEVICE_INFO_SERVICE_UUID],[CBUUID UUIDWithString:POLARH7_HRM_HEART_RATE_SERVICE_UUID]];
    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    // 1 开始扫描service  连接搜索到的peripheral
    [centralManager scanForPeripheralsWithServices:services options:nil];
    
    // 14 重连已知的peripheral列表中的peripheral 以前发现过或以前连接过的
    //第一次连接上peripheral并且系统自动生成identifier之后，需要保存下来，当再次连接时读出来
    //该方法返回CBperipheral数组，包含以前连接过的CBPeripheral，如果数组为空，没找到，需要尝试另外两种方法
    //如果有多个，应该让用户去选择连接哪一个
    //如果用户选择了一个Peripheral, 那么connectPeripheral:options方法来连接，成功连接之后依然会走centralManager:didConnectPeripheral
    // [centralManager retrievePeripheralsWithIdentifiers:@[identifiers]];
    
    //重连当前系统已经连接的peripheral  返回一个数组【CBPeripheral】
    // [centralManager retrieveConnectedPeripheralsWithServices:@[]];
    self.centralManager = centralManager;
    
    
    //自动连接
    // 在程序启动或者需要使用蓝牙的时候,判断是否需要自动连接，如需要，尝试连接已知的peripheral
    //在 periperal 的引用释放之后，连接会自动取消 因此必须强引用
    //在使用 retrievePeripheralsWithIdentifiers: 方法将之前记录的 peripheral 读取出来，然后我们去调用 connectPeripheral:options: 方法来进行重新连接
    
    //Core Bluetooth没有处理连接超时的操作，超时的操作需要自己维护一个timer,在start scan时启动，找到了periperal之后 stop timier
    //如果超时了，stop scan, 提示用户手动自动重连
    
    // 蓝牙名称更新 在 peripheral 修改名字过后，iOS 存在搜索到蓝牙名字还未更新的问题
}

#pragma mark - CBCentralManagerDelegate
//12 当连接当断开的时候会调用
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}
// 5 : 和periphera 建立了连接
//成功的连接到了一个BLE peripheral ，记录当前的连接状态等数据
//第一次成功连接到了peripheral之后，ios设备会自动给peripheral生成一个identifier(NSUUID) CBPeer提供
//因为 iOS 拿不到 peripheral 的 MAC 地址，所以无法唯一标识每个硬件设备，根据这个注释来看，应该 Apple 更希望你使用这个 identifer 而不是 MAC 地址。值得注意的是，不同的 iOS 连接同一个 peripheral 获得的 identifier 是不一样的。所以如果一定要获得唯一的 MAC 地址，可以和硬件工程师协商，让 peripheral 返给你

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSArray *services = @[[CBUUID UUIDWithString:POLARH7_HRM_DEVICE_INFO_SERVICE_UUID],[CBUUID UUIDWithString:POLARH7_HRM_HEART_RATE_SERVICE_UUID]];

    [peripheral setDelegate:self];
    [peripheral discoverServices:services];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@",self.connected);
}
// 6:如果连接建立失败调用
// 连接失败的原因  :  peripheral 与 central 的距离超出了连接范围
//                 有一些 BLE 设备的地址是周期性变化的。所以，即使 peripheral 就在旁边，如果它的地址已经变化，而你记录的地址已经变化了，那么也是连接不上的。如果是因为这种原因连接不上，那你需要调用 scanForPeripheralsWithServices:options: 方法来进行重新搜索
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}
// 3 发现了一个peripheral,每发现一个peripheral，都会调用该方法
//获取BLE peripheral 的大部分信息  RSSI: 信号强度，可以用它来评估central 和 peripheral之间的距离
// 当central 和 peripheral之间的距离足够近时，才开始去读或者写数据
//在这里需要筛选出自己的目标peripheral,筛选出以后，调用stopscan 方法停止扫描
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        NSLog(@"Found the heart rate monitor: %@", localName);
        [self.centralManager stopScan];
        self.polarHRH7MPeripheral = peripheral;
        peripheral.delegate = self;
        //4 建立连接
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

//设备状态改变时调用  2 判断设备状态 是否支持蓝牙等等
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    } else if([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
    }else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBlueTooth BLE state is unauthorized");
    }else if([central state] == CBManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknow");
    }else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardeware is unsupported on this device");
    }
}

#pragma  mark - CBPeripheralDelegate

// 7
//发现peripheral 的可用的services时调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) { //遍历的方法找到自己所关心的service
        NSLog(@"Discovered service: %@", service.UUID);
        //去发现 Characteristics  搜索当前service的 Characteristics
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// 8
//发现指定service的对应characteristics 时调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if ([service.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_HEART_RATE_SERVICE_UUID]]) {
        
        //需要读取characteristics 的属性，去判断是否支持可读，是否支持订阅（实时读取）
        for (CBCharacteristic *aChar in service.characteristics) {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MEASUREMENT_CHARACTERISTIC_UUID]]) {
            
                //告诉CBCentralManager 去观察 characteristic 的改变
                //为了实时获取数据，需要订阅该characteristic,如果订阅成功会回调peripheral:didUpdateNotificationStateForCharacteristic:error
                BOOL isSupport = aChar.properties & (CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite | CBCharacteristicPropertyNotify); //判断读写可订阅
                if (isSupport) {
                    [self.polarHRH7MPeripheral setNotifyValue:YES forCharacteristic:aChar];

                }
                NSLog(@"Found heart rate measurement characteristic");
            }else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_CHARACTERISTIC_UUID]]) {
               //如果是位置信息，只读  会回调方法 peripheral:didUpdateValueForCharacteristic:error
                //该方法并不是实时的，如果用到实时，比如读取心率，那就要调用方法setNotifyValue:forCharacteristic来订阅Characteristic
                
                BOOL isSupport = aChar.properties & (CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite ); //判断读写

                if (isSupport) {
                    //读数据
                    [self.polarHRH7MPeripheral readValueForCharacteristic:aChar];
                    
                    //写数据  如果 characteristic 可写
                    //type就是CBCharacteristicWriteWithResponse表示写入成功时进行回调，回调方法为peripheral:didWriteValueForCharacteristic:error
                   // [peripheral writeValue:dataToWrite forCharacteristic:interestingCharacteristic type:CBCharacteristicWriteWithResponse];
                    
                }
                NSLog(@"Found body sensor location characteristic");
            }
        }
    }
    
    //获取设备信息
    if ([service.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_DEVICE_INFO_SERVICE_UUID]]) {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID]]) {
                [self.polarHRH7MPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a device manufacturer name characteristic");
            }
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

// 10 订阅成功与否的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if(error) {
        //订阅错误
    }
    
}
// 11 characteristic 写入成功时回调,如果失败，error包含失败的信息
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}
// 9 CBPeripheral reads a value (or updates a value periodically).
//获取指定的characteristic 的值  或者 peripheral 设备通知app characteristic's值已经改变
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MEASUREMENT_CHARACTERISTIC_UUID]]) {
        //得到心率检测的BPM
        [self getHeartBPMData:characteristic error:error];
    }
    
    // Retrieve the characteristic value for manufacturer name received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID]]) {  // 2
        [self getManufacturerName:characteristic];
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_CHARACTERISTIC_UUID]]) {  // 3
        [self getBodyLocation:characteristic];
    }
    
    NSLog(@"%@\n%@\n%@\n", self.connected, self.bodyData, self.manufacturer);
}

#pragma mark - CBCharacteristic helpers

// Instance method to get the heart rate BPM information
- (void) getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Get the Heart Rate Monitor BPM
    NSData *data = [characteristic value];      // 1
    const uint8_t *reportData = [data bytes];
    uint16_t bpm = 0;
    
    if ((reportData[0] & 0x01) == 0) {          // 2
        // Retrieve the BPM value for the Heart Rate Monitor
        bpm = reportData[1];
    }
    else {
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));  // 3
    }
    // Display the heart rate value to the UI if no error occurred
    if( (characteristic.value)  || !error ) {   // 4
        self.heartRate = bpm;
        self.heartRateBPM.text = [NSString stringWithFormat:@"%i bpm", bpm];
        self.heartRateBPM.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:28];
        [self doHeartBeat];
        self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
    }
    return;
}


//再次连接 peripheral



// Instance method to get the manufacturer name of the device
- (void) getManufacturerName:(CBCharacteristic *)characteristic
{
    NSString *manufacturerName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];  // 1
    self.manufacturer = [NSString stringWithFormat:@"Manufacturer: %@", manufacturerName];    // 2
    return;
}
// Instance method to get the body location of the device
- (void) getBodyLocation:(CBCharacteristic *)characteristic
{
    NSData *sensorData = [characteristic value];         // 1
    uint8_t *bodyData = (uint8_t *)[sensorData bytes];
    if (bodyData ) {
        uint8_t bodyLocation = bodyData[0];  // 2
        self.bodyData = [NSString stringWithFormat:@"Body Location: %@", bodyLocation == 1 ? @"Chest" : @"Undefined"]; // 3
    }
    else {  // 4
        self.bodyData = [NSString stringWithFormat:@"Body Location: N/A"];
    }
    return;
}
// Helper method to perform a heartbeat animation
- (void)doHeartBeat {
}



@end

//读写数据

