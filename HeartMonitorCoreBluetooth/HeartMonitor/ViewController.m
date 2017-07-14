//
//  ViewController.m
//  HeartMonitor
//
//  Created by GK on 2017/6/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

#import "ViewController.h"
@import CoreBluetooth;

@interface ViewController ()<CBCentralManagerDelegate>
@property (nonatomic,strong) CBCentralManager *centralManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    NSArray *services = @[[CBUUID UUIDWithString:POLARH7_HRM_DEVICE_INFO_SERVICE_UUID],[CBUUID UUIDWithString:POLARH7_HRM_HEART_RATE_SERVICE_UUID]];

    [self.centralManager scanForPeripheralsWithServices:services options:nil];
}


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
@end
