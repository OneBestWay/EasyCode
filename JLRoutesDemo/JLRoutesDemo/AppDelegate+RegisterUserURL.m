//
//  AppDelegate+RegisterUserURL.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/23.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "AppDelegate+RegisterUserURL.h"
#import "UserInformationViewController.h"

@implementation AppDelegate (RegisterUserURL)

- (void)userApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [JLRoutes addRoute:@"/:object/:action/:primaryKey" handler:^BOOL(NSDictionary * _Nonnull parameters) {
        
        NSString *JLRouteURL = parameters[@"JLRouteURL"];
        NSString *JLRoutePattern = parameters[@"JLRoutePattern"];
        NSString *JLRouteNamespace = parameters[@"JLRouteNamespace"];
        
        NSString *object = parameters[@"object"];
        NSString *action = parameters[@"action"];
         BOOL debug = [parameters[@"debug"] boolValue];
        NSString *foo = parameters[@"foo"];
        
        NSInteger primaryKey = [parameters[@"primaryKey"] doubleValue];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
        UserInformationViewController *userInfoVC = [storyboard instantiateViewControllerWithIdentifier:[UserInformationViewController uniqueIDentifier]];

        userInfoVC.userID = primaryKey;

        userInfoVC.parseURLString = [NSString stringWithFormat:@"object:%@\n action:%@\n primaryKey:%@\n debug:%@\n foo:%@,RouteURL:%@\n,RoutePattern:%@\n,RoutesnameSpace:%@",object,action,@(primaryKey),debug?@"true":@"false",foo,JLRouteURL,JLRoutePattern,JLRouteNamespace];
        
        [nav pushViewController:userInfoVC animated:YES];
        return YES;
    }];
}
@end
