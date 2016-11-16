//
//  NSArray+GroupedComponents.m
//  Category
//
//  Created by GK on 2016/11/15.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "NSArray+GroupedComponents.h"

@implementation NSArray (GroupedComponents)

- (NSString *)groupedComponentsWith:(NSLocale *)locale
{
    if (self.count < 1) {
        return @"";
    }else if (self.count < 2) {
        return self[0];
    }else if (self.count < 3){
        NSString *joiner = NSLocalizedString(@"", @"");
        return [NSString stringWithFormat:@"%@%@%@",self[0],joiner,self[1]];
    }else {
        NSString *joiner = [NSString stringWithFormat:@"%@ ", [locale objectForKey:NSLocaleGroupingSeparator]];
        NSArray *first = [self subarrayWithRange:NSMakeRange(0, self.count - 1)];
        NSMutableString *result = [NSMutableString stringWithString:[first componentsJoinedByString:joiner]];
        
        NSString *lastJoiner = NSLocalizedString(@",", @"and");
        [result appendString:lastJoiner];
        [result appendString:self.lastObject];
        return result;
    }
}
@end
