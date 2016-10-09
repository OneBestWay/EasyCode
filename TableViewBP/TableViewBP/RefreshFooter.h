//
//  RefreshFooter.h
//  TableViewBP
//
//  Created by GK on 16/10/4.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FooterViewBeginRefresh)(void);
extern  CGFloat const headerThresholdValue;

@interface RefreshFooter : NSObject
@property (strong, nonatomic) IBOutlet UIView *view;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) FooterViewBeginRefresh footerViewBeginRefresh;

- (instancetype)initScrollView:(UIScrollView *)scrollView;

- (void)endRefreshing;
- (void)beginRefreshing;

- (void)noMoreData; //没有加载到数据时调用
- (void)loadError; //加载错误时调用

@end
