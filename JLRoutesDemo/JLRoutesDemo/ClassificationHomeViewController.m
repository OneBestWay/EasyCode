//
//  ClassificationHomeViewController.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/24.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "ClassificationHomeViewController.h"

@interface ClassificationHomeViewController ()

@end

@implementation ClassificationHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)superMarketButtonClicked:(UIButton *)sender
{
    NSURL *viewUserURL = [NSURL URLWithString:@"JLRoutesDemo://home/supermarket?debug=true&foo=bar"];
    [[UIApplication sharedApplication] openURL:viewUserURL options:@{} completionHandler:nil];
}
- (IBAction)globalBuyButtonClicked:(UIButton *)sender
{
    NSURL *viewUserURL = [NSURL URLWithString:@"JLRoutesDemo://home/globalbuy?debug=true&foo=bar"];
    [[UIApplication sharedApplication] openURL:viewUserURL options:@{} completionHandler:nil];
}


@end
