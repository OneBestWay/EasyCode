//
//  RegularTransferOrders.m
//  SNYifubao
//
//  Created by GK on 2017/6/23.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "RegularTransferOrders.h"
#import "RegularTransferOrderInfo.h"

@interface RegularTransferOrders() <NSCopying,NSMutableCopying>

@end

@implementation RegularTransferOrders

- (instancetype)initWithJSON:(NSDictionary *)jsonDict {
    self = [super init];
    if (self) {
        self.maxTaskNumber = [jsonDict[@"maxTaskNum"] integerValue];
        self.amount = [jsonDict[@"totalPayAmount"] floatValue];
        self.month = [jsonDict[@"currentMonth"] integerValue];
        self.payMount = [jsonDict[@"todoPayAmount"] floatValue];
        self.payedAmount = [jsonDict[@"payedAmount"] floatValue];
        self.failNumber = [jsonDict[@"currentMonthFailNum"] integerValue];
    
        id bizOrders = jsonDict[@"RegularBizOrder"];
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        
        if ([bizOrders isKindOfClass:[NSArray class]]) {
            NSArray *tempOrders = (NSArray *)bizOrders;
            for (id jsonOrder in tempOrders) {
                if ([jsonOrder isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = (NSDictionary *)jsonOrder;
                    RegularTransferOrderInfo *info = [[RegularTransferOrderInfo alloc] initWithJSON:dict];
                    [temp addObject:info];
                }
            }
        }
        
        self.orders = [NSArray arrayWithArray:temp];
    }
    return self;
}


- (instancetype)copyWithZone:(NSZone *)zone {
    RegularTransferOrders *info = [[RegularTransferOrders alloc] init];
    info.maxTaskNumber = self.maxTaskNumber;
    info.month = self.month;
    info.payedAmount = self.payedAmount;
    info.amount = self.amount;
    info.payMount = self.payMount;
    info.failNumber = self.failNumber;
    info.nextMonthAmount = self.nextMonthAmount;
    info.orders = [self.orders copy];
    return  info;
}
- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    RegularTransferOrders *info = [[RegularTransferOrders alloc] init];
    info.maxTaskNumber = self.maxTaskNumber;
    info.month = self.month;
    info.payedAmount = self.payedAmount;
    info.amount = self.amount;
    info.payMount = self.payMount;
    info.failNumber = self.failNumber;
    info.nextMonthAmount = self.nextMonthAmount;
    info.orders = [self.orders mutableCopy];
    return info;
}

@end
