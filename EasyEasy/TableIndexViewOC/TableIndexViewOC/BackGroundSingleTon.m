//
//  BackGroundSingleTon.m
//  TableIndexViewOC
//
//  Created by GK on 2017/10/13.
//  Copyright © 2017年 GK. All rights reserved.
//

#import "BackGroundSingleTon.h"
#import <UIKit/UIKit.h>

@interface BackGroundSingleTon()
@property (nonatomic) UIBackgroundTaskIdentifier backIdentifier;
@end
@implementation BackGroundSingleTon
+ (instancetype)instance {
    static BackGroundSingleTon *_backtask;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _backtask = [[BackGroundSingleTon alloc] init];
        [_backtask setupBackgrounding];
    });
    return _backtask;
}
- (void)setupBackgrounding {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(appBackgrounding:)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(appForegrounding:)
                                                 name: UIApplicationWillEnterForegroundNotification
                                               object: nil];
}
- (void)appBackgrounding: (NSNotification *)notification {
    [self keepAlive];
}
- (void)keepAlive {
    self.backIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication]  endBackgroundTask:self.backIdentifier];
        self.backIdentifier = UIBackgroundTaskInvalid;
        [self keepAlive];
    }];
}
- (void)appForegrounding: (NSNotification *)notification {
    if (self.backIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backIdentifier];
        self.backIdentifier = UIBackgroundTaskInvalid;
    }
}
@end
