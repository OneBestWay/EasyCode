//
//  NSString+Additions.h
//  TableViewBP
//
//  Created by GK on 2016/10/9.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqual:@"null"]) || ([(_ref) isEqual:@"(null)"]))
//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

@interface NSString (Additions)
+ (NSString *)generateGuid;
- (NSString *)MD5EncodedString;

- (NSString *)urlByAppendingDictNoEncode:(NSDictionary *)params;

@end
