//
//  RefreshFooter.m
//  TableViewBP
//
//  Created by GK on 16/10/4.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "RefreshFooter.h"

#define COLOR_RGB(r, g, b) COLOR_RGBA(r, g, b, 1.0f)
#define COLOR_RGBA(r, g, b, a) [UIColor colorWithRed:((r) / 255.0f)    \
green:((g) / 255.0f)    \
blue:((b) / 255.0f)    \
alpha:((a) / 1.0f)]

CGFloat const footerHeight = 50;
CGFloat const footerThresholdValue = 10;

@interface RefreshFooter()
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat scrollViewheight;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,strong) CABasicAnimation *animation;

@property (nonatomic) CGFloat contentHeight;
@property (nonatomic) BOOL isRefresh;
@end
@implementation RefreshFooter

- (instancetype)initScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        
        self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.scrollViewheight = 0;
        self.isRefresh = NO;
        self.imageView.hidden = YES;
        
        self.scrollView = scrollView;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        NSString *className = NSStringFromClass([self class]);
        self.view = (UIView*)[[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        [self.scrollView addSubview:self.view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadErrorAction)];
        [self.view addGestureRecognizer:tap];
        self.view.userInteractionEnabled = NO;
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]) {
        return;
    }
    
    self.contentHeight = self.scrollView.contentSize.height;
    self.scrollViewheight = self.scrollView.frame.size.height;

    if (self.scrollView.contentOffset.y <= -headerThresholdValue) {
        self.isRefresh = NO;
        self.statusLabel.hidden = YES;
        return;
    }
    if (self.scrollView.isDragging) {
        self.imageView.transform = CGAffineTransformMakeRotation((self.scrollView.contentOffset.y * 3 * M_PI) / footerHeight);
    }
    self.view.frame = CGRectMake(0, self.contentHeight, self.screenWidth, footerHeight);
    
    CGFloat currentPosition = self.scrollView.contentOffset.y - self.scrollView.contentInset.bottom;
    
    if (currentPosition > (self.contentHeight - self.scrollViewheight) && (self.contentHeight > self.scrollViewheight)) {
        [self beginRefreshing];
    }
}

- (void)beginRefreshing
{
    if (self.isRefresh) {
        return;
    }
    self.isRefresh = YES;
    self.statusLabel.hidden = YES;
    
    [self startAnimating];
    
    __weak typeof(self) weakSelf = self;
    //刷新scrollview 的位置
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __strong typeof(self) strongSelf = weakSelf;

        [UIView animateWithDuration:0.3 animations:^{
            strongSelf.scrollView.contentInset = UIEdgeInsetsMake(0, 0, footerHeight, 0);
        }];
        //回掉block
        strongSelf.footerViewBeginRefresh();
    });
}

- (void)endRefreshing
{
    if (!self.isRefresh) {
        return;
    }
    self.isRefresh = NO;

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            //停止动画
            [strongSelf stopAnimating];
            strongSelf.scrollView.contentInset = UIEdgeInsetsMake(0, 0, footerHeight, 0);
            strongSelf.view.frame = CGRectMake(0, strongSelf.contentHeight, strongSelf.screenWidth, footerHeight);
        }];
    });
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
    self.imageView.hidden = NO;
    if (![self.imageView.layer animationForKey:@"animation"]) {
        [self.imageView.layer addAnimation:self.animation forKey:@"animation"];
    }
}
- (void)stopAnimating
{
    self.imageView.hidden = YES;
    [self.imageView.layer removeAllAnimations];
}

- (void)noMoreData
{
    self.statusLabel.hidden = NO;
    self.statusLabel.text = @"没有数据了";
    [self endRefreshing];
    self.isRefresh = YES;
}
- (void)loadError
{
    self.view.userInteractionEnabled = YES;
    self.statusLabel.hidden = NO;
    self.statusLabel.text = @"加载失败，点击重试";
    [self endRefreshing];
}
- (void)loadErrorAction
{
    self.statusLabel.hidden = YES;
    [self beginRefreshing];
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
