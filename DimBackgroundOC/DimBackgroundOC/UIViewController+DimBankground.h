//
//  UIViewController+DimBankground.h
//  DimBackgroundOC
//
//  Created by GK on 2016/11/16.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

enum Direction {
    kIn , kOut
};
@interface UIViewController (DimBankground)


- (void)dim:(enum Direction) direction color:(UIColor *)color alpha:(CGFloat) alpha speed:(CGFloat)speed;

@end
