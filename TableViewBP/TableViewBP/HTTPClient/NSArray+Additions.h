//
//  NSArray+Additions.h
//  TableViewBP
//
//  Created by GK on 2016/10/10.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)
- (NSArray *)arrayByRemovingNullRecursively:(BOOL)recursive;
- (NSArray *)arrayByRemovingNull;
@end

