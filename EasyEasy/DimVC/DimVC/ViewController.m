//
//  ViewController.m
//  DimVC
//
//  Created by GK on 2017/10/12.
//  Copyright © 2017年 GK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<DimViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)toDimVC:(UIButton *)sender {
    DimViewController *dimVC = [[DimViewController alloc] init];
    dimVC.delegate = self;
    dimVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    dimVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    dimVC.view.backgroundColor = [UIColor clearColor];
    [self dim: kIn color:[UIColor blackColor] alpha:0.5 speed:0.7];
    [self presentViewController:dimVC animated:YES completion:nil];
}
- (void)dismissDimVC {
    [self dim:kOut color:[UIColor blackColor] alpha:0 speed:0.3];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
