//
//  UserInformationViewController.m
//  JLRoutesDemo
//
//  Created by GK on 16/9/23.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "UserInformationViewController.h"

@interface UserInformationViewController ()

@end

@implementation UserInformationViewController

+ (NSString*)uniqueIDentifier
{
    return NSStringFromClass([UserInformationViewController class]);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userIDLabel.text = [NSString stringWithFormat:@"userID: %lf",self.userID];
    self.ParseURL.text = self.parseURLString;
}


@end
