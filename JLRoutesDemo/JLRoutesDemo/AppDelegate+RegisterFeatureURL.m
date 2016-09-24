//
//  AppDelegate+RegisterFeatureURL.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/23.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "AppDelegate+RegisterFeatureURL.h"
#import "HotProductViewController.h"
#import "RecommendProductViewController.h"

@implementation AppDelegate (RegisterFeatureURL)
- (void)featureApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //匹配以feature开头的所有URL 形如： JLRoutesDemo://feature/*
    [JLRoutes addRoute:@"/feature/*" handler:^BOOL(NSDictionary * _Nonnull parameters) {
        
        NSArray *pathComponents = parameters[kJLRouteWildcardComponentsKey];
        
        if (pathComponents > 0 ) {
           
            if ([pathComponents[0] isEqualToString:@"hot"]) {
                
                NSString *JLRouteURL = parameters[@"JLRouteURL"];
                NSString *JLRoutePattern = parameters[@"JLRoutePattern"];
                NSString *JLRouteNamespace = parameters[@"JLRouteNamespace"];
                
                BOOL debug = [parameters[@"debug"] boolValue];
                NSString *foo = parameters[@"foo"];
                
                NSInteger primaryKey = [parameters[@"primaryKey"] doubleValue];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Feature" bundle:nil];
                UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
                HotProductViewController *userInfoVC = [storyboard instantiateViewControllerWithIdentifier:[HotProductViewController uniqueIDentifier]];
                
                
                userInfoVC.parseURLString = [NSString stringWithFormat:@"primaryKey:%@\n debug:%@\n foo:%@,RouteURL:%@\n,RoutePattern:%@\n,RoutesnameSpace:%@",@(primaryKey),debug?@"true":@"false",foo,JLRouteURL,JLRoutePattern,JLRouteNamespace];
                
                [nav pushViewController:userInfoVC animated:YES];
                
                return YES;
            }else if ([pathComponents[0] isEqualToString:@"recommend"]){
                
                NSString *JLRouteURL = parameters[@"JLRouteURL"];
                NSString *JLRoutePattern = parameters[@"JLRoutePattern"];
                NSString *JLRouteNamespace = parameters[@"JLRouteNamespace"];
                
                BOOL debug = [parameters[@"debug"] boolValue];
                NSString *foo = parameters[@"foo"];
                
                NSInteger primaryKey = [parameters[@"primaryKey"] doubleValue];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Feature" bundle:nil];
                UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
                RecommendProductViewController *userInfoVC = [storyboard instantiateViewControllerWithIdentifier:[RecommendProductViewController uniqueIDentifier]];
                
                
                userInfoVC.parseURLString = [NSString stringWithFormat:@"primaryKey:%@\n debug:%@\n foo:%@,RouteURL:%@\n,RoutePattern:%@\n,RoutesnameSpace:%@",@(primaryKey),debug?@"true":@"false",foo,JLRouteURL,JLRoutePattern,JLRouteNamespace];
                
                [nav pushViewController:userInfoVC animated:YES];
                return YES;
            }
            
            return NO;
        }
        return NO;
    }];
}

@end
