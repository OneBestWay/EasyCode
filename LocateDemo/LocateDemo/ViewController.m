//
//  ViewController.m
//  LocateDemo
//
//  Created by GK on 2016/10/10.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "ViewController.h"
#import "LocateCity.h"

#define IOS10_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 )
@interface ViewController () <LocateCityDelegate>
@property (weak, nonatomic) IBOutlet UILabel *LocateStatusLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.LocateStatusLabel.text = @"正在努力定位中...";
    [LocateCity shareInstance].delegate = self;
    
    [self locateDevice];
    
}

- (void)locateDevice
{
    if ([[LocateCity shareInstance] deviceSupportLocateService]) {
        if ([[LocateCity shareInstance] isOpenLocateService]) {
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"要使用此功能请前往设置界面，打开定位" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.LocateStatusLabel.text = @"没有打开定位，定位失败";
            }];
            UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (IOS10_OR_LATER) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
                }
            }];
            
            [alertVC addAction:cancelAction];
            [alertVC addAction:openAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            
        }else {
            [[LocateCity shareInstance] startUpdatingLocation];
        }
        
    }else {
        
        self.LocateStatusLabel.text = @"该设备不支持定位";
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"你的设备不支持定位功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
- (void)locateCityCompletedWithlocateStatus:(NSInteger)locateStatus
{
    switch (locateStatus) {
        case LocateSuccess:{
            //能得到经度和纬度和详细地址
            self.LocateStatusLabel.text = [LocateCity shareInstance].locateCityDTO.cityName;
            break;
        }
        case LocateDetailAdddressFail: {
            self.LocateStatusLabel.text = @"定位成功，获取详细地址失败";
             break;
        }
        default:
            //定位失败
            self.LocateStatusLabel.text = @"定位失败";
            break;
    }
}
- (void)appEnterForground
{
    [self locateDevice];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
