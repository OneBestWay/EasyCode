//
//  DispatchTimeExtensions.swift
//  SwiftExtensions
//
//  Created by GK on 2016/12/6.
//  Copyright © 2016年 GK. All rights reserved.
//

import Foundation

//扩展DispachTime,产生将来的一个时间
extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}
