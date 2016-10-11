//
//  LocateCity.h
//  LocateDemo
//
//  Created by GK on 2016/10/10.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, LocateErrorCode) {
    LocateSuccess = 0, //定位成功
    LocateFail,     //定位失败
    LocateDetailAdddressFail, //获取详细地址信息失败
    LocateCityServiceUnable, //定位服务不可用
    LocateCityUserDenied, //用户不允许定位
};
#define UserChangeAuthorizationStatusKey  @"UserChangeAuthorizationStatusKey"
#define AppEnterForegroundKey  @"AppEnterForegroundKey"

@interface LocateCityDTO : NSObject
@property (nonatomic, strong) NSDictionary *addressInfoDic; //地址信息dic
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic) CLLocationCoordinate2D coordinate; //定位到的当前坐标
@end

@protocol LocateCityDelegate <NSObject>
@optional
- (void)locateCityCompletedWithlocateStatus:(NSInteger)locateStatus;
- (void)appEnterForground;
@end

@interface LocateCity : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) LocateCityDTO *locateCityDTO;
@property (nonatomic) enum LocateErrorCode status; //定位状态
@property (nonatomic, weak) id <LocateCityDelegate> delegate;

@property (nonatomic) BOOL didChangeAuthorizationStatus; //YES: 用户授权定位状态改变为可用，NO：改变为不可用
+ (instancetype)shareInstance;
- (void)startUpdatingLocation;

- (BOOL)deviceSupportLocateService;
- (BOOL)isOpenLocateService;

@end
