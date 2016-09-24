//
//  ViewController.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/22.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}
- (IBAction)toFeatureRecommendClicked:(UIButton *)sender
{
    NSURL *viewUserURL = [NSURL URLWithString:@"JLRoutesDemo://home/supermarket?debug=true&foo=bar"];
    [[UIApplication sharedApplication] openURL:viewUserURL options:@{} completionHandler:nil];

}
- (IBAction)toFeatureClicked:(UIButton *)sender
{
    NSURL *viewUserURL = [NSURL URLWithString:@"JLRoutesDemo://home/globalbuy?debug=true&foo=bar"];
    [[UIApplication sharedApplication] openURL:viewUserURL options:@{} completionHandler:nil];

}
- (IBAction)bestPracticeClicked:(UIButton *)sender
{
    NSURL *viewUserURL = [NSURL URLWithString:@"JLRoutesDemo://product/user?debug=true&foo=bar"];
    [[UIApplication sharedApplication] openURL:viewUserURL options:@{} completionHandler:nil];
    
}
- (IBAction)customSchemeClicked:(UIButton *)sender
{
   
    NSURL *viewUserURL = [NSURL URLWithString:@"Product://user?debug=true&foo=bar"];
    [[UIApplication sharedApplication] openURL:viewUserURL options:@{} completionHandler:nil];
}

- (IBAction)toUserInfoButtonClicked:(UIButton *)sender {
    
    NSURL *viewUserURL = [NSURL URLWithString:@"JLRoutesDemo://user/view/10090?debug=true&foo=bar"];
    [[UIApplication sharedApplication] openURL:viewUserURL options:@{} completionHandler:nil];

}
- (IBAction)notFoundCustomScheme:(UIButton *)sender
{
    NSURL *viewUserURL = [NSURL URLWithString:@"Product://user/view/10090?debug=true&foo=bar"];
    [[UIApplication sharedApplication] openURL:viewUserURL options:@{} completionHandler:nil];
    
    [JLRoutes routesForScheme:@"Product"].shouldFallbackToGlobalRoutes = YES;
}

@end
