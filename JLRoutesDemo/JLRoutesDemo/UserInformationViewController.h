//
//  UserInformationViewController.h
//  JLRoutesDemo
//
//  Created by GK on 16/9/23.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UITextView *ParseURL;


@property (nonatomic) double userID;
@property (nonatomic,strong) NSString *parseURLString;
+ (NSString*)uniqueIDentifier;
@end
