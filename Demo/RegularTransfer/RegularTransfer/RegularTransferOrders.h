//
//  RegularTransferOrders.h
//  SNYifubao
//
//  Created by GK on 2017/6/23.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface RegularTransferOrders : NSObject
@property (nonatomic) NSInteger maxTaskNumber; //最大任务数
@property (nonatomic) NSInteger month;//当前月份
@property (nonatomic) CGFloat payedAmount; //已还金额
@property (nonatomic) CGFloat amount;// 当前月份总金额
@property (nonatomic) CGFloat payMount; //待还金额
@property (nonatomic) NSInteger failNumber; // 当月失败的笔数

@property (nonatomic) CGFloat nextMonthAmount;// 下月待还总金额

@property (nonatomic,strong) NSArray *orders;// 存放RegularTransferOrderInf的数组
@end
