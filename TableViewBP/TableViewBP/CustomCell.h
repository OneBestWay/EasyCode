//
//  CustomCell.h
//  TableViewBP
//
//  Created by GK on 16/10/3.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+(NSString*)cellIdentifier;
@end
