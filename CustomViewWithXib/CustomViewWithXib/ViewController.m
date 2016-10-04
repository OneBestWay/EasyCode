//
//  ViewController.m
//  CustomViewWithXib
//
//  Created by GK on 16/10/2.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "ViewController.h"
#import "ShowView.h"

@interface ViewController ()
@property (nonatomic,strong) ShowView *showView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.showView];
}
- (IBAction)popCustomView:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT - 400, SCREEN_WIDTH, 400);
    }];
}
- (IBAction)dismissView:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT + 400, SCREEN_WIDTH, 400);
    }];
}

- (ShowView *)showView {
    if (!_showView) {
        _showView = [[ShowView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT + 400, SCREEN_WIDTH, 400)];
    }
    return _showView;
    
}

-(void)dealloc {
    [self.showView removeFromSuperview];
    self.showView = nil;
}
@end
