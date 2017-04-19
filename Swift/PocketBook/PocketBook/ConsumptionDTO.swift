//
//  PocketHomeData.swift
//  PocketBook
//
//  Created by GK on 2017/3/11.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

enum ParseError: Error {
    case missing(String)
}

struct ConsumptionDTO {
    var patterns: String //消费说明
    
    var type: Int //消费类型 1：服饰 2：交通 ....
    var typeString: String? //消费类型所对应的字符串 服饰，购物 ...
    var favourite: Bool = false //自动判断，消费做多的就是最喜欢的
    var iconName: String  //图标

    fileprivate var dateString: String  //消费日期字符串
    var date: Date? //消费日期
    var showDateString: String? //消费日期用于显示
    
    var ammount: String //金额
    var showAmountString: String? //金额的字符串
    
    var paymentType: Int  //0 : 未分类 1 : 现金 2: 支付宝 3：银行卡、信用卡
    var paymentMethod: String //支付方式 如 现金 支付宝 招商银行 未分类
    
    var paymentTips: String  //支付方式的补充说明  如 尾号0345 招商银行，或余额 + 余额宝
    
    var changeType: Bool // 0: 支出 1：收入
    var paymentCode: String
}
extension ConsumptionDTO {
    init?(json: [String: Any]) throws {
        guard let patterns = json["patterns"] as? String else {
            throw ParseError.missing("patterns")
        }
        guard let type = json["type"] as? Int else {
            throw ParseError.missing("type")
        }
        guard let dateString = json["dateString"] as? String else {
            throw ParseError.missing("dateString")
        }
        guard let ammount = json["ammount"] as? String else {
            throw ParseError.missing("ammount")
        }
        
        guard let changeType = json["changeType"] as? Bool else {
            throw ParseError.missing("changeType")
        }
        
        if let paymentCode = json["paymentCode"] as?  String {
            self.paymentCode = paymentCode
        }else {
            self.paymentCode = ""
        }
        
        if let iconName = json["iconName"] as? String {
            self.iconName = iconName
        }else {
            self.iconName = "defaultIcon"
        }
        guard let paymentMethod = json["paymentMethod"] as? String else {
            throw ParseError.missing("paymentMethod")
        }

        if let paymentType = json["paymentType"] as? Int  {
            self.paymentType = paymentType
        }else {
            self.paymentType = 0
        }
        if let paymentTips = json["paymentTips"] as? String {
            self.paymentTips = paymentTips
        }else {
            if self.paymentType == 0 {
                self.paymentTips = "默认账户"
            }else {
                self.paymentTips = ""
            }
        }
        guard let paymentTips = json["paymentTips"] as? String else {
            throw ParseError.missing("paymentTips")
        }
        self.patterns = patterns
        self.type = type
        self.dateString = dateString
        self.ammount = ammount
        self.paymentMethod = paymentMethod
        self.paymentTips = paymentTips
        self.changeType = changeType
    }
}
