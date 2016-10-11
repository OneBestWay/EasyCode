//
//  LocateCity.m
//  LocateDemo
//
//  Created by GK on 2016/10/10.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "LocateCity.h"
#import <UIKit/UIKit.h>

#define IOS8_OR_LATER	( [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0 )

@implementation LocateCityDTO

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

@interface LocateCity () <CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLGeocoder *geocoder;
@end
@implementation LocateCity

+ (instancetype)shareInstance
{
    static LocateCity *locateCity = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locateCity = [[LocateCity alloc] init];
    });
    return locateCity;
}

- (instancetype)init
{
    if (self == [super init]) {
        self.locateCityDTO = [[LocateCityDTO alloc] init];
        self.didChangeAuthorizationStatus = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForground) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)startUpdatingLocation
{
    if (![CLLocationManager locationServicesEnabled]) {
        self.status = LocateCityServiceUnable;
        [self locateFinished];
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        self.status = LocateCityUserDenied;
        [self locateFinished];
        return;
    }
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    if (IOS8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    [self.locationManager startUpdatingLocation];
    
    //60s 后自动取消定位
    [self performSelector:@selector(stopUpdateLocation) withObject:nil afterDelay:60.0];
    
}
- (void)stopUpdateLocation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdateLocation) object:nil];
    [self.locationManager stopUpdatingLocation];
}
- (void)locateFinished
{
    if (self.status == LocateSuccess) {
        //保存上一次定位成功的信息到NSUserDefaults
    }else if (self.status == LocateDetailAdddressFail) {
        //保存上一次定位的经度和纬度到NSUserDefaults
    }
    
    if ([self.delegate respondsToSelector:@selector(locateCityCompletedWithlocateStatus:)]) {
        [self.delegate locateCityCompletedWithlocateStatus:self.status];
    }
}

#pragma mark -- locationmanager delegate
//定位成功回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    __weak typeof(self) weakSelf = self;
    CLLocation *newLocation = (CLLocation *)[locations firstObject];
    self.locateCityDTO.coordinate = newLocation.coordinate;
    
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (error || placemarks == nil || [placemarks count] == 0) {
            strongSelf.status = LocateDetailAdddressFail;
            [strongSelf locateFinished];
        }else {
            
            for (CLPlacemark *placemark in placemarks) {
                strongSelf.locateCityDTO.addressInfoDic = [[NSDictionary alloc] initWithDictionary:placemark.addressDictionary];
                NSString *city = [placemark.addressDictionary objectForKey:@"City"];
                if (city && city.length > 0) {
                    city = [placemark.addressDictionary objectForKey:@"State"];
                }
                strongSelf.locateCityDTO.cityName = city;
                NSLog(@"locate city is : %@",city);
                break;
            }
            strongSelf.didChangeAuthorizationStatus = NO;
            strongSelf.status = LocateSuccess;
            [strongSelf locateFinished];
        }
    }];
    
    [self stopUpdateLocation];
    
}
//定位失败回调
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location error : %@",[error localizedDescription]);
    [self stopUpdateLocation];
    self.status = LocateFail;
    [self locateFinished];
}

- (void)appEnterForground
{
    if (self.didChangeAuthorizationStatus && [self.delegate respondsToSelector:@selector(appEnterForground)]) {
        [self.delegate appEnterForground];
    }
}
-(void)dealloc
{
    [self stopUpdateLocation];
    self.locationManager.delegate = nil;
    [self.geocoder cancelGeocode];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AppEnterForegroundKey object:nil];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;
        }
        case kCLAuthorizationStatusDenied: {
            self.status = LocateCityUserDenied;
            self.didChangeAuthorizationStatus = YES;
            break;
        }
        default:{
            self.didChangeAuthorizationStatus = YES;

            break;
        }
    }
}
- (BOOL)deviceSupportLocateService
{
    return [CLLocationManager locationServicesEnabled];
}
- (BOOL)isOpenLocateService
{
    BOOL userDenied = NO;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        self.status = LocateCityUserDenied;
        userDenied = YES;
    }
    return userDenied;
}
@end
