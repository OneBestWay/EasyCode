//
//  HRMViewController.h
//  HeartMonitor
//
//  Created by Main Account on 12/13/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreBluetooth;
@import QuartzCore;

//由于心率检测是公共UUID,由SIG官方提供，  如果是自己公司的产品，需要硬件方便自定义UUID
#define POLARH7_HRM_DEVICE_INFO_SERVICE_UUID @"180A"  // for device info
#define POLARH7_HRM_HEART_RATE_SERVICE_UUID @"180D"   //for heart rate service

#define POLARH7_HRM_MEASUREMENT_CHARACTERISTIC_UUID @"2A37"   //heart rate measurement
#define POLARH7_HRM_BODY_LOCATION_CHARACTERISTIC_UUID @"2A38" // body sensor location
#define POLARH7_HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID @"2A29" //manufacturer name string

@interface HRMViewController : UIViewController

// Instance method to get the heart rate BPM information
- (void) getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error;

// Instance methods to grab device Manufacturer Name, Body Location
- (void) getManufacturerName:(CBCharacteristic *)characteristic;
- (void) getBodyLocation:(CBCharacteristic *)characteristic;

// Instance method to perform heart beat animations
- (void) doHeartBeat;

@end

/*:https://race604.com/gatt-profile-intro/   
 https://learn.adafruit.com/introduction-to-bluetooth-low-energy?view=all
BLE是建立在GATT协议之上的，GATT是一个在蓝牙连接之上发送和接收很短的数据段的通用规范，这些很短的数据段称为属性
GAT: 控制设备的连接和广播
GATT协议独占的， BLE 外设同时只能被一个中心设备连接，一旦连接就会停止广播

 
1  只扫描需要的peripheral，扫描时不会自动超时，所以需要手动设置timer 去停掉，如果只需要连接一个 peripheral，那应该在 centralManager:didConnectPeripheral: 的回调中，用 stopScan 方法停止搜索
2  在需要接收数据的时候，调用 readValueForCharacteristic:，这种是需要主动去接收的。
   用 setNotifyValue:forCharacteristic: 方法订阅，当有数据发送时，可以直接在回调中接收。
   如果 characteristic 的数据经常变化，那么采用订阅的方式更好。
 
在不用和 peripheral 通信的时候，应当将连接断开，这也对节能有好处。在以下两种情况下，连接应该被断开：
 
当 characteristic 不再发送数据时。（可以通过 isNotifying 属性来判断）
你已经接收到了你所需要的所有数据时。

 注意：cancelPeripheralConnection: 是非阻塞性的，如果在 peripheral 挂起的状态去尝试断开连接，那么这个断开操作可能执行，也可能不会。因为可能还有其他的 central 连着它，所以取消连接并不代表底层连接也断开。从 app 的层面来讲，在 peripheral 决定断开的时候，会调用 CBCentralManagerDelegate  的 centralManager:didDisconnectPeripheral:error: 方法。er:didDisconnectPeripheral:error: 方法。
 
 再次连接 peripheral
 
 Core Bluetooth 提供了三种再次连接 peripheral 的方式：
 
 调用 retrievePeripheralsWithIdentifiers: 方法，重连已知的 peripheral 列表中的 peripheral（以前发现的，或者以前连接过的）。
 调用 retrieveConnectedPeripheralsWithServices: 方法，重新连接当前【系统】已经连接的 peripheral。
 调用 scanForPeripheralsWithServices:options: 方法，连接搜索到的 peripheral。

*/
