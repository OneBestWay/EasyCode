//
//  RefreshHeader.m
//  TableViewBP
//
//  Created by GK on 16/10/4.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "RefreshHeader.h"

#define COLOR_RGB(r, g, b) COLOR_RGBA(r, g, b, 1.0f)
#define COLOR_RGBA(r, g, b, a) [UIColor colorWithRed:((r) / 255.0f)    \
green:((g) / 255.0f)    \
blue:((b) / 255.0f)    \
alpha:((a) / 1.0f)]

CGFloat const headerHeight = 50;
CGFloat const headerThresholdValue = 80;

@interface RefreshHeader()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imagwView;

@property (nonatomic,strong) CABasicAnimation *animation;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat scrollViewheight;
@property (nonatomic) CGFloat lastPosition;
@property (nonatomic) CGFloat contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;

@property (nonatomic,strong) NSString *statusText;
@property (nonatomic) BOOL isRefresh;

@end
@implementation RefreshHeader


- (instancetype)initScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        
        self.statusLabel.hidden = YES;
        
        self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.scrollViewheight = 0;
        self.lastPosition = 0;
        self.isRefresh = NO;
        
        self.scrollView = scrollView;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        NSString *className = NSStringFromClass([self class]);
        self.headerView = (UIView*)[[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        self.statusText = @"更新中...";
        [self.scrollView addSubview:self.headerView];
        
        self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]) return;
    
    self.contentHeight = self.scrollView.contentSize.height;
    
    self.headerView.frame = CGRectMake(0, -headerHeight - 10, self.screenWidth, headerHeight);

    if (self.scrollView.dragging) { // 正在拖动scrollView
        CGFloat currentPosition = self.scrollView.contentOffset.y - self.scrollView.contentInset.bottom;
        self.imagwView.transform = CGAffineTransformMakeRotation(( currentPosition* 3 * M_PI) / headerHeight);

        if(!self.isRefresh){ //正在拖动 -> 没有刷新
            [UIView animateWithDuration:0.3 animations:^{
                
                if (currentPosition < -headerThresholdValue) { //当向下拖动到达临界值
                    self.statusText = @"松开刷新";
                }else {
                    //判断滑动方向，@"松开开始刷新" -> @"下拉开始刷新"
                    if (currentPosition - self.lastPosition > 5) {
                        self.lastPosition = currentPosition;
                        self.statusText = @"下拉刷新";
                    }else if (self.lastPosition - currentPosition > 5){
                        self.lastPosition = currentPosition;
                    }
                }
            }];
        }
    }else {
        if ([self.statusLabel.text isEqualToString:@"松开刷新"]) { //开始刷新
            [self beginRefreshing];
        }
    }
}

- (CABasicAnimation *)animation
{
    if (!_animation) {
        _animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _animation.fromValue = [NSNumber numberWithFloat:0.0];
        _animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        _animation.duration = 1.0f;
        _animation.repeatCount = HUGE_VAL;
        
    }
    return _animation;
}
- (void)startAnimating
{
    if (![self.imagwView.layer animationForKey:@"animation"]) {
        [self.imagwView.layer addAnimation:self.animation forKey:@"animation"];
    }
}
- (void)stopAnimating
{
    [self.imagwView.layer removeAllAnimations];
}
- (void)beginRefreshing
{
    if (self.isRefresh) {
        return;
    }
    
    self.isRefresh = YES;
    
    self.statusLabel.text = @"更新中...";
    [self startAnimating];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollView.contentInset = UIEdgeInsetsMake(headerThresholdValue, 0, 0, 0);
    });
    
    self.headerViewBeginRefresh();
}

- (void)endRefreshing
{
    if (!self.isRefresh) {
        return;
    }
    self.isRefresh = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            [self stopAnimating];
        }];
    });

    
}
- (void)setStatusText:(NSString *)statusText
{
    _statusText = statusText;
    
    self.statusLabel.text = _statusText;
    CGSize size = [self.statusLabel.text sizeWithAttributes:@{NSFontAttributeName:self.statusLabel.font}];
    self.viewWidthConstraints.constant = self.imageViewWidthConstraint.constant + size.width + 10;
    
}
- (void)setStatusLabel:(UILabel *)statusLabel
{
    _statusLabel = statusLabel;
    
    _statusLabel.textColor = COLOR_RGB(0xae, 0xae, 0xae);
    _statusLabel.font = [UIFont systemFontOfSize:13];
}
- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
