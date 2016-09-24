//
//  AppDelegate.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/22.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+RegisterHomeVCURL.h"
#import "AppDelegate+RegisterClassificationVCURL.h"
#import "AppDelegate+RegisterFindVCURL.h"
#import "AppDelegate+RegisterMineVCURL.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册各个模块的View Controller的URL
    [self homeApplication:application didFinishLaunchingWithOptions:launchOptions];
    [self classificationApplication:application didFinishLaunchingWithOptions:launchOptions];
//    [self findApplication:application didFinishLaunchingWithOptions:launchOptions];
//    [self mineApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [JLRoutes routeURL:url];
}


@end
