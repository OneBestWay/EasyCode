//
//  AppDelegate+RegisterHomeVCURL.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/24.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "AppDelegate+RegisterHomeVCURL.h"
#import "GlobalBuyHomeViewController.h"
#import "SupermarketHomeViewController.h"

@implementation AppDelegate (RegisterHomeVCURL)

- (void)homeApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    //匹配以home开头的所有URL 形如： JLRoutesDemo://home/*
    [JLRoutes addRoute:@"/home/*" handler:^BOOL(NSDictionary * _Nonnull parameters) {
        
        NSArray *pathComponents = parameters[kJLRouteWildcardComponentsKey];
        
        if (pathComponents > 0 ) {
            
            UITabBarController *tabbarVC = (UITabBarController*)self.window.rootViewController;
            
            UINavigationController *nav =  (UINavigationController*)tabbarVC.selectedViewController;

            if ([pathComponents[0] isEqualToString:@"globalbuy"]) {
                
                NSString *JLRouteURL = parameters[@"JLRouteURL"];
                NSString *JLRoutePattern = parameters[@"JLRoutePattern"];
                NSString *JLRouteNamespace = parameters[@"JLRouteNamespace"];
                
                BOOL debug = [parameters[@"debug"] boolValue];
                NSString *foo = parameters[@"foo"];
                
                NSInteger primaryKey = [parameters[@"primaryKey"] doubleValue];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            
                GlobalBuyHomeViewController *userInfoVC = [storyboard instantiateViewControllerWithIdentifier:[GlobalBuyHomeViewController uniqueIdentifier]];
                
                
                userInfoVC.parseURLString = [NSString stringWithFormat:@"primaryKey:%@\n debug:%@\n foo:%@\n,RouteURL:%@\n,RoutePattern:%@\n,RoutesnameSpace:%@",@(primaryKey),debug?@"true":@"false",foo,JLRouteURL,JLRoutePattern,JLRouteNamespace];
                
                [nav pushViewController:userInfoVC animated:YES];
                
                return YES;
            }else if ([pathComponents[0] isEqualToString:@"supermarket"]){
                
                NSString *JLRouteURL = parameters[@"JLRouteURL"];
                NSString *JLRoutePattern = parameters[@"JLRoutePattern"];
                NSString *JLRouteNamespace = parameters[@"JLRouteNamespace"];
                
                BOOL debug = [parameters[@"debug"] boolValue];
                NSString *foo = parameters[@"foo"];
                
                NSInteger primaryKey = [parameters[@"primaryKey"] doubleValue];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
                SupermarketHomeViewController *userInfoVC = [storyboard instantiateViewControllerWithIdentifier:[SupermarketHomeViewController uniqueIdentifier]];
                
                
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
