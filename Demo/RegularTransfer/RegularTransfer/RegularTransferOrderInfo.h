//
//  RegularTransferOrderInfo.h
//  SNYifubao
//
//  Created by GK on 2017/6/23.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum RegularTransferType: NSInteger {
    mortgage = 1,
    carloan,
    parents,
    child,
    others
};

@interface RegularTransferOrderInfo : NSObject

@property (nonatomic,strong) NSString *orderIdentifier;//订单ID

@property (nonatomic) CGFloat amount;   //金额
@property (nonatomic,strong) NSString *account; //收款账户
@property (nonatomic,strong) NSString *name; //收款人姓名
@property (nonatomic) NSInteger day; // 1-28
@property (nonatomic,strong) NSString *payOrder;// 支付顺序(1,2,3) 1:零钱包 2: 余额宝 3 快捷卡
@property (nonatomic) enum RegularTransferType type; //1:还房贷 2 车贷 3 给父母 4 给子女 5给他
@property (nonatomic,strong) NSString *remark; //备注
@property (nonatomic,strong) NSString *payeePhone; //收款人手机号码
@property (nonatomic,strong) NSString *leaveMessage;// 收款人留言
@property (nonatomic) NSString *typeString; //
@property (nonatomic,strong) NSString *expectedTime; //转账预期时间

@property (nonatomic,strong) NSString *helpCenterLink; //帮助中心链接

@property (nonatomic) NSInteger numDayAfter;// 多少天后
@property (nonatomic,strong) NSString *status;// 业务状态
@property (nonatomic,strong) NSString *statusName;// 状态名字
@property (nonatomic,strong) NSString *errorDesc; //转账失败描述

@property (nonatomic) BOOL isCanEdit; //是否可以编辑
- (instancetype)initWithJSON:(NSDictionary *)jsonDict;

@end
