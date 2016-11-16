//
//  NSString+Additions.m
//  Category
//
//  Created by GK on 2016/11/15.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *)initials
{
    NSMutableString *result = [NSMutableString string];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByWords | NSStringEnumerationLocalized usingBlock:^(NSString * _Nullable word, NSRange wordRange, NSRange enclosingWordRange, BOOL * _Nonnull stop1) {
        
        __block NSString *firstLetter = nil;
        [self enumerateSubstringsInRange: enclosingWordRange options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable letter, NSRange letterRange, NSRange enclosingRange, BOOL * _Nonnull stop2) {
            firstLetter = letter;
           
            *stop2 = YES;
        }];
        if (firstLetter != nil) {
            [result appendString:firstLetter];
        }
    }];
    
    return [result uppercaseStringWithLocale:[NSLocale currentLocale]];
}
- (NSString *)deletePrefix:(NSString *)prefix
{
    if (prefix == nil || prefix.length == 0) {
        return self;
    }
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    
    NSRange r = [self rangeOfString:prefix options:NSAnchoredSearch range:NSMakeRange(0, self.length) locale:nil];
    
    if (r.location != NSNotFound) {
        [mutableString deleteCharactersInRange:r];
        return mutableString;
    }
    return self;
}
@end
