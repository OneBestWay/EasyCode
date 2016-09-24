//
//  HotProductViewController.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/23.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "HotProductViewController.h"

@interface HotProductViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HotProductViewController

+ (NSString *)uniqueIDentifier
{
    return NSStringFromClass([HotProductViewController class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"热门产品";

    self.textView.text = self.parseURLString;
}


@end
