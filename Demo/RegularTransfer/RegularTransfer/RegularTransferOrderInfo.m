//
//  RegularTransferOrderInfo.m
//  SNYifubao
//
//  Created by GK on 2017/6/23.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "RegularTransferOrderInfo.h"

@interface RegularTransferOrderInfo() <NSCopying,NSMutableCopying>

@end

@implementation RegularTransferOrderInfo

- (instancetype)initWithJSON:(NSDictionary *)jsonDict {
    self = [super init];
    if (self) {
        self.orderIdentifier = [NSString stringWithFormat:@"%@",jsonDict[@"bizOrderId"]];
        self.amount = [jsonDict[@"transferAmount"] floatValue];
        self.account = [NSString stringWithFormat:@"%@",jsonDict[@"payeeCardNo"]];
        self.name = [NSString stringWithFormat:@"%@",jsonDict[@"payeeUserName"]];;
        self.day = [jsonDict[@"payeeUserName"] integerValue];
        self.payOrder = [NSString stringWithFormat:@"%@",jsonDict[@"paySequence"]];
        self.type = [jsonDict[@"transferType"] integerValue];
        self.remark = [NSString stringWithFormat:@"%@",jsonDict[@"remark"]];
        self.payeePhone = [NSString stringWithFormat:@"%@",jsonDict[@"payeeUserPhone"]];
        self.leaveMessage = [NSString stringWithFormat:@"%@",jsonDict[@"messageContent"]];
        self.expectedTime = [NSString stringWithFormat:@"%@",jsonDict[@"arrivalAccountTime"]];
        self.numDayAfter = [jsonDict[@"numDayAfter"] integerValue];
        self.status = [NSString stringWithFormat:@"%@",jsonDict[@"bizStatus"]];
        self.statusName = [NSString stringWithFormat:@"%@",jsonDict[@"showStatusName"]];
        self.errorDesc = [NSString stringWithFormat:@"%@",jsonDict[@"errorDesc"]];
        self.isCanEdit = [jsonDict[@"isEdit"] boolValue];
    }
    return self;
}
- (instancetype)copyWithZone:(NSZone *)zone {
    RegularTransferOrderInfo *info = [[RegularTransferOrderInfo alloc] init];
    info.orderIdentifier = [self.orderIdentifier copy];
    info.amount = self.amount;
    info.account = [self.account copy];
    info.name = [self.name copy];
    info.day = self.day;
    info.payOrder = [self.payOrder copy];
    info.type = self.type;
    info.remark = [self.remark copy];
    info.payeePhone = [self.payeePhone copy];
    info.leaveMessage = [self.leaveMessage copy];
    info.expectedTime = [self.expectedTime copy];
    info.numDayAfter = self.numDayAfter;
    info.status = [self.status copy];
    self.statusName = [self.statusName copy];
    info.errorDesc = [self.errorDesc copy];
    info.isCanEdit = self.isCanEdit;
    return  info;
}
- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    RegularTransferOrderInfo *info = [[RegularTransferOrderInfo alloc] init];
    info.orderIdentifier = [self.orderIdentifier mutableCopy];
    info.amount = self.amount;
    info.account = [self.account copy];
    info.name = [self.name copy];
    info.day = self.day;
    info.payOrder = [self.payOrder copy];
    info.type = self.type;
    info.remark = [self.remark copy];
    info.payeePhone = [self.payeePhone copy];
    info.leaveMessage = [self.leaveMessage copy];
    info.expectedTime = [self.expectedTime copy];
    info.numDayAfter = self.numDayAfter;
    info.status = [self.status mutableCopy];
    self.statusName = [self.statusName mutableCopy];
    info.errorDesc = [self.errorDesc mutableCopy];
    info.isCanEdit = self.isCanEdit;
    return info;
}
- (NSString *)typeString {
    
    NSString *typeString = @"";
    
    switch (self.type) {
        case mortgage: {
            typeString = @"还房贷";
            break;
        }
        case carloan: {
            typeString = @"还车贷";
            break;
        }
        case parents: {
            typeString = @"给父母";
            break;
        }
        case child:{
            typeString = @"给子女";
            break;
        }
        case others: {
            typeString = @"给Ta";
            break;
        }
    }
    return  typeString;
}
@end
