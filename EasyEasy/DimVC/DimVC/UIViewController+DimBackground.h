//
//  UIViewController+DimBackground.h
//  DimVC
//
//  Created by GK on 2017/10/12.
//  Copyright © 2017年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

enum Direction {
    kIn , kOut
};
@interface UIViewController (DimBackground)
- (void)dim:(enum Direction) direction color:(UIColor *)color alpha:(CGFloat) alpha speed:(CGFloat)speed;
@end
