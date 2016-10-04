//
//  ShowView.m
//  CustomViewWithXib
//
//  Created by GK on 16/10/2.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "ShowView.h"

@interface ShowView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation ShowView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewSetup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self viewSetup];
    }
    return self;
}

- (void)viewSetup {
    
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.borderWidth = 2;
    self.titleLabel.font = [UIFont systemFontOfSize:20 weight:2];
    
    self.backgroundColor = [UIColor colorWithRed:147/250.0 green:147/250.0 blue:147/250.0 alpha:1];
    
}
@end
