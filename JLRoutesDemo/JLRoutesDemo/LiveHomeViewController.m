//
//  LiveHomeViewController.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/24.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "LiveHomeViewController.h"

@interface LiveHomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation LiveHomeViewController

+ (NSString *)uniqueIdentifier
{
    return NSStringFromClass([LiveHomeViewController class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = self.parseURLString;
}


@end
