//
//  UIViewController+DimBackground.m
//  DimVC
//
//  Created by GK on 2017/10/12.
//  Copyright © 2017年 GK. All rights reserved.
//

#import "UIViewController+DimBackground.h"

@implementation UIViewController (DimBackground)
- (void)dim:(enum Direction) direction color:(UIColor *)color alpha:(CGFloat) alpha speed:(CGFloat)speed
{
    UIView *tempView = [self getTargetViewControllerView];
    
    switch (direction) {
        case kIn:{
            UIView *dimView = [[UIView alloc] initWithFrame:tempView.frame];
            dimView.backgroundColor = color;
            dimView.alpha = 0.0;
            [tempView addSubview:dimView];
            
            dimView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[dimView]|" options:0 metrics:nil views:@{@"dimView":dimView}]];
            [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dimView]|" options:0 metrics:nil views:@{@"dimView":dimView}]];
            
            [UIView animateWithDuration:speed animations:^{
                dimView.alpha = alpha;
            }];
            break;
        }
        case kOut:{
            [UIView animateWithDuration:speed animations:^{
                tempView.subviews.lastObject.alpha = alpha;
            } completion:^(BOOL finished) {
                [tempView.subviews.lastObject removeFromSuperview];
            }];
            break;
        }
    }
}
- (UIView *)getTargetViewControllerView {
    UIView *tempView = self.navigationController.view;
    if (tempView == nil) {
        tempView = self.view;
    }
    return tempView;
}
@end
