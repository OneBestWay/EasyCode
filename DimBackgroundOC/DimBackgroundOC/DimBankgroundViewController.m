//
//  DimBankgroundViewController.m
//  DimBackgroundOC
//
//  Created by GK on 2016/11/16.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "DimBankgroundViewController.h"

@interface DimBankgroundViewController ()

@end

@implementation DimBankgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 300, 300)];
    view.backgroundColor = [UIColor whiteColor];
    
    view.layer.cornerRadius = 10;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 0.25;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.6;
    view.layer.shadowRadius = 15;
    view.layer.shadowOffset = CGSizeMake(5, 5);
    view.layer.masksToBounds = false;
    
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
