//
//  HomeRootViewController.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/24.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "HomeRootViewController.h"

@interface HomeRootViewController ()

@end

@implementation HomeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)liveButtonClicked:(id)sender
{
    NSURL *viewUserURL = [NSURL URLWithString:@"JLRoutesDemo://classification/live?debug=true&foo=bar"];
    [[UIApplication sharedApplication] openURL:viewUserURL options:@{} completionHandler:nil];
}

- (IBAction)advisoryButtonClicked:(UIButton *)sender
{
    NSURL *viewUserURL = [NSURL URLWithString:@"JLRoutesDemo://classification/advisory?debug=true&foo=bar"];
    [[UIApplication sharedApplication] openURL:viewUserURL options:@{} completionHandler:nil];
}

@end
