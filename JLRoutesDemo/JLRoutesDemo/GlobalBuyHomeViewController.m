//
//  GlobalBuyHomeViewController.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/24.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "GlobalBuyHomeViewController.h"

@interface GlobalBuyHomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation GlobalBuyHomeViewController

+ (NSString *)uniqueIdentifier
{
    return NSStringFromClass([GlobalBuyHomeViewController class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = self.parseURLString;
}



@end
