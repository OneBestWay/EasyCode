//
//  recommendProductViewController.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/23.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "RecommendProductViewController.h"

@interface RecommendProductViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation RecommendProductViewController

+ (NSString *)uniqueIDentifier
{
    return NSStringFromClass([RecommendProductViewController class]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"推荐的产品";
    self.textView.text = self.parseURLString;

}


@end
