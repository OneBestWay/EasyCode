//
//  DimViewController.m
//  DimBackgroundOC
//
//  Created by GK on 2017/4/24.
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
    
    self.lineViewHeightConstraint.constant = 0.5;
    
    self.alertView.layer.cornerRadius = 10;
    self.alertView.layer.borderColor = [UIColor blackColor].CGColor;
    self.alertView.layer.borderWidth = 0.25;
    self.alertView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.alertView.layer.shadowOpacity = 0.6;
    self.alertView.layer.shadowRadius = 15;
    self.alertView.layer.shadowOffset = CGSizeMake(5, 5);
    self.alertView.layer.masksToBounds = false;
    
    self.bodyText.text = @"1. 输入收款方姓名和手机号，输入转账金额支付成功后，收款方将立即收到短信，根据短信提示回复银行卡号（限储蓄卡）后，资金将实时入账。\n2. 如果收款方在次日21:30分之前未回复卡号，则交易自动解除，资金原路退回。\n3. 如果收款方手机号已经回复过银行卡号，则支付成功后默认向该银行卡打款。";
}

- (IBAction)dismissVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
