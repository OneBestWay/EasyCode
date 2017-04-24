//
//  ViewController.m
//  DimBackgroundOC
//
//  Created by GK on 2016/11/16.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+DimBankground.h"
#import "DimBankgroundViewController.h"
#import "DimViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)clicked:(id)sender {
    
    DimBankgroundViewController *dimVC = [[DimBankgroundViewController alloc] init];
    
    dimVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    dimVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self dim: kIn color:[UIColor blackColor] alpha:0.5 speed:0.5];
    [self presentViewController:dimVC animated:YES completion:nil];
}
- (IBAction)aletViewController:(UIButton *)sender {
    DimViewController *dimVC = [[DimViewController alloc] init];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [self presentViewController:dimVC animated:YES completion:nil];
    }
    
}


@end
