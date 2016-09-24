//
//  AppDelegate+RegisterClassificationVCURL.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/24.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "AppDelegate+RegisterClassificationVCURL.h"
#import "LiveHomeViewController.h"
#import "AdvisoryViewController.h"

@implementation AppDelegate (RegisterClassificationVCURL)

- (void)classificationApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
   

    //匹配以home开头的所有URL 形如： JLRoutesDemo://classification/*
    [JLRoutes addRoute:@"/classification/*" handler:^BOOL(NSDictionary * _Nonnull parameters) {
        
        NSArray *pathComponents = parameters[kJLRouteWildcardComponentsKey];
        
        if (pathComponents > 0 ) {
            
            UITabBarController *tabbarVC = (UITabBarController*)self.window.rootViewController;
            
            UINavigationController *nav =  (UINavigationController*)tabbarVC.selectedViewController;
            
            if ([pathComponents[0] isEqualToString:@"live"]) {
                
                NSString *JLRouteURL = parameters[@"JLRouteURL"];
                NSString *JLRoutePattern = parameters[@"JLRoutePattern"];
                NSString *JLRouteNamespace = parameters[@"JLRouteNamespace"];
                
                BOOL debug = [parameters[@"debug"] boolValue];
                NSString *foo = parameters[@"foo"];
                
                NSInteger primaryKey = [parameters[@"primaryKey"] doubleValue];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Classification" bundle:nil];
                
                LiveHomeViewController *userInfoVC = [storyboard instantiateViewControllerWithIdentifier:[LiveHomeViewController uniqueIdentifier]];
                
                
                userInfoVC.parseURLString = [NSString stringWithFormat:@"primaryKey:%@\n debug:%@\n foo:%@\n,RouteURL:%@\n,RoutePattern:%@\n,RoutesnameSpace:%@",@(primaryKey),debug?@"true":@"false",foo,JLRouteURL,JLRoutePattern,JLRouteNamespace];
                
                [nav pushViewController:userInfoVC animated:YES];
                
                return YES;
            }else if ([pathComponents[0] isEqualToString:@"advisory"]){
                
                NSString *JLRouteURL = parameters[@"JLRouteURL"];
                NSString *JLRoutePattern = parameters[@"JLRoutePattern"];
                NSString *JLRouteNamespace = parameters[@"JLRouteNamespace"];
                
                BOOL debug = [parameters[@"debug"] boolValue];
                NSString *foo = parameters[@"foo"];
                
                NSInteger primaryKey = [parameters[@"primaryKey"] doubleValue];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Classification" bundle:nil];
                AdvisoryViewController *userInfoVC = [storyboard instantiateViewControllerWithIdentifier:[AdvisoryViewController uniqueIdentifier]];
                
                
                userInfoVC.parseURLString = [NSString stringWithFormat:@"primaryKey:%@\n debug:%@\n foo:%@\n,RouteURL:%@\n,RoutePattern:%@\n,RoutesnameSpace:%@",@(primaryKey),debug?@"true":@"false",foo,JLRouteURL,JLRoutePattern,JLRouteNamespace];
                
                [nav pushViewController:userInfoVC animated:YES];
                return YES;
            }
            
            return NO;
        }
        return NO;
    }];
}
@end
