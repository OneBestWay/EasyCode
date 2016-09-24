//
//  AdvisoryViewController.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/24.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "AdvisoryViewController.h"

@interface AdvisoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AdvisoryViewController

+ (NSString *)uniqueIdentifier
{
    return NSStringFromClass([AdvisoryViewController class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = self.parseURLString;
}


@end
