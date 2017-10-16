//
//  DimViewController.m
//  DimVC
//
//  Created by GK on 2017/10/12.
//  Copyright © 2017年 GK. All rights reserved.
//

#import "DimViewController.h"

@interface DimViewController ()

@end

@implementation DimViewController

- (instancetype)init {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[self class]]];
    
    self = [storyBoard instantiateViewControllerWithIdentifier:@"DimViewController"];
    if (self) {
        
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
        return  self;
    }
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.alertView.layer.cornerRadius = 10;
//    self.alertView.layer.borderColor = [UIColor blackColor].CGColor;
//    self.alertView.layer.borderWidth = 0.25;
//    self.alertView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.alertView.layer.shadowOpacity = 0.6;
//    self.alertView.layer.shadowRadius = 15;
//    self.alertView.layer.shadowOffset = CGSizeMake(5, 5);
//    self.alertView.layer.masksToBounds = false;
}
- (IBAction)closeButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(dismissDimVC)]) {
        [self.delegate dismissDimVC];
    }
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
