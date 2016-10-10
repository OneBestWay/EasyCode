//
//  NSString+Additions.m
//  TableViewBP
//
//  Created by GK on 2016/10/9.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)
+ (NSString *)generateGuid {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString	*uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}
- (NSString *)MD5EncodedString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5EncodedString];
}

- (NSString *)urlByAppendingDictNoEncode:(NSDictionary *)params
{
    if (IsNilOrNull(params)) {
        return self;
    }
    
    NSURL *parsedURL = [NSURL URLWithString:self];
    if (!parsedURL) {
        return self;
    }
    
    NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [params keyEnumerator]) {
        id value = [params valueForKey:key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }else {
            continue;
        }
        [pairs addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
    }
    
    NSString *query = [pairs componentsJoinedByString:@"&"];
    return [NSString stringWithFormat:@"%@%@%@",self,queryPrefix,query];
}
@end
