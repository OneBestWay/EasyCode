//
//  NSDictionary+Additions.m
//  TableViewBP
//
//  Created by GK on 2016/10/10.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "NSDictionary+Additions.h"
#import "NSArray+Additions.h"

@implementation NSDictionary (Additions)

- (NSDictionary*)dictionaryByRemovingNull
{
    return [self dictionaryByRemovingNullRecursively:YES];
}

- (NSDictionary*)dictionaryByRemovingNullRecursively:(BOOL)recursive
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self];
    
    for (id key in [self allKeys]) {
        id object = [self objectForKey:key];
        
        if (object == [NSNull null]) {
            [dictionary removeObjectForKey:key];
        }
        
        if (recursive) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *subdictionary = [object dictionaryByRemovingNullRecursively:YES];
                [dictionary setValue:subdictionary forKey:key];
            }
            
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray *subarray = [object arrayByRemovingNullRecursively:YES];
                [dictionary setValue:subarray forKey:key];
            }
        }
    }
    
    return [dictionary copy];
}

@end
