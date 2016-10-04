//
//  CustomView.m
//  zhoumowan
//
//  Created by GK on 16/8/6.
//  Copyright © 2016年 Yock.L. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSString *className = NSStringFromClass([self class]);
        _customView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        _customView.frame = self.bounds;
        if(CGRectIsEmpty(frame)) {
            self.bounds = _customView.bounds;
        }
        
        [self addSubview:_customView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        
        NSString *className = NSStringFromClass([self class]);
        _customView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        _customView.frame = self.bounds;
        [self addSubview:_customView];
        
    }
    return self;
}

@end
