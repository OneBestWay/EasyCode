//
//  SupermarketHomeViewController.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/24.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "SupermarketHomeViewController.h"

@interface SupermarketHomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SupermarketHomeViewController

+ (NSString*)uniqueIdentifier
{
    return NSStringFromClass([SupermarketHomeViewController class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = self.parseURLString;
}

@end
