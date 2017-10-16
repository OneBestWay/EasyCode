//
//  DimViewController.h
//  DimVC
//
//  Created by GK on 2017/10/12.
//  Copyright © 2017年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DimViewControllerDelegate <NSObject>
- (void)dismissDimVC;

@end
@interface DimViewController : UIViewController
@property (nonatomic,weak) id<DimViewControllerDelegate> delegate;
@end
