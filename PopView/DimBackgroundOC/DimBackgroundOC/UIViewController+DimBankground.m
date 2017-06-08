//
//  UIViewController+DimBankground.m
//  DimBackgroundOC
//
//  Created by GK on 2016/11/16.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "UIViewController+DimBankground.h"

@implementation UIViewController (DimBankground)
- (void)dim:(enum Direction) direction color:(UIColor *)color alpha:(CGFloat) alpha speed:(CGFloat)speed
{
    switch (direction) {
        case kIn:{
            
            UIView *dimView = [[UIView alloc] initWithFrame:self.view.frame];
            dimView.backgroundColor = color;
            dimView.alpha = 0.0;
            [self.view addSubview:dimView];
            
            dimView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[dimView]|" options:0 metrics:nil views:@{@"dimView":dimView}]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dimView]|" options:0 metrics:nil views:@{@"dimView":dimView}]];
            
            [UIView animateWithDuration:speed animations:^{
                dimView.alpha = alpha;
            }];
            break;
        }
        case kOut:{
            [UIView animateWithDuration:speed animations:^{
                self.view.subviews.lastObject.alpha = alpha;
            } completion:^(BOOL finished) {
                [self.view.subviews.lastObject removeFromSuperview];
            }];
            break;
        }
    }
}
@end
