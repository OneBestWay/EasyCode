//
//  RefreshHeader.h
//  TableViewBP
//
//  Created by GK on 16/10/4.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HeaderViewBeginRefresh) (void);
extern  CGFloat const headerThresholdValue;

@interface RefreshHeader : NSObject

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HeaderViewBeginRefresh headerViewBeginRefresh;

- (instancetype)initScrollView:(UIScrollView *)scrollView;

- (void)endRefreshing;
- (void)beginRefreshing;

@end
