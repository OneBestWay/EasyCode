//
//  NSArray+Additions.m
//  TableViewBP
//
//  Created by GK on 2016/10/10.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "NSArray+Additions.h"
#import "NSDictionary+Additions.h"

@implementation NSArray (Additions)
- (NSArray *)arrayByRemovingNullRecursively:(BOOL)recursive
{
    NSMutableArray *array = [self mutableCopy];
    
    for (id object in self) {
        if (object == [NSNull null]) {
            [array removeObject:object];
        }
        if (recursive) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSInteger index = [array indexOfObject:object];
                NSDictionary *subDictionary = [object dictionaryByRemovingNullRecursively:YES];
                [array replaceObjectAtIndex:index withObject:subDictionary];
            }
            if ([object isKindOfClass:[NSArray class]]) {
                NSInteger index = [array indexOfObject:object];
                NSArray *subArray = [object arrayByRemovingNullRecursively:YES];
                [array replaceObjectAtIndex:index withObject:subArray];
            }
        }
    }
    return [array copy];
}
- (NSArray *)arrayByRemovingNull
{
    return [self arrayByRemovingNullRecursively:YES];
}
@end

