//
//  DimViewController.h
//  DimBackgroundOC
//
//  Created by GK on 2017/4/24.
//  Copyright © 2017年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DimViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *bodyText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeightConstraint;

@end
