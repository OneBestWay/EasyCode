//
//  NSString+Additions.h
//  Category
//
//  Created by GK on 2016/11/15.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)
- (NSString *) initials;  //获取字符串单词的首字母
- (NSString *) deletePrefix: (NSString *)prefix; //去掉字符串的前缀
@end
