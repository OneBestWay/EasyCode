//
//  CustomCell.m
//  TableViewBP
//
//  Created by GK on 16/10/3.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "CustomCell.h"
#define COLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CustomCell

+(NSString *)cellIdentifier{
    return NSStringFromClass([self class]);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = COLOR_HEX(0x0b0b0b);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
