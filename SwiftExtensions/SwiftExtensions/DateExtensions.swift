//
//  DateExtensions.swift
//  SwiftExtensions
//
//  Created by GK on 2016/12/2.
//  Copyright © 2016年 GK. All rights reserved.
//

import Foundation


extension Calendar {
    
    //计算任意一天的开始，可以间接计算任意一天的结束
    func startOfDay(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool = false) -> Date? {
        guard let newDate = self.date(byAdding: component, value: value, to: date, wrappingComponents: wrappingComponents) else {
            return nil
        }
        
        return self.startOfDay(for: newDate)
    }
}

extension Date {
    // 返回据当前日期的时间间隔，例如一小时以前，两分钟以前
    func timeAgoString() -> String? {
        let components = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: self, to: Date())
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        if components.year != nil , components.year != 0 {
            formatter.allowedUnits = .year
        }else if components.month != nil ,components.month != 0 {
            formatter.allowedUnits = .month
        }else if components.day != nil ,components.day != 0 {
            formatter.allowedUnits = .day
        }else if components.hour != nil ,components.hour != 0 {
            formatter.allowedUnits = .hour
        }else if components.minute != nil ,components.minute != 0 {
            formatter.allowedUnits = .minute
        }else {
            formatter.allowedUnits = .second
        }
        
        guard let timeString = formatter.string(from: components) else {
            return nil
        }
        
        return String(format: NSLocalizedString("%@ ago", comment: "Format string for relative time ago"), timeString)
    }
    
    //得到当前日期之前的日期，例如1小时以前的日期，一个月以前的日期
    func getDate(daysAgo days: Double = 0, hoursAgo hours: Double = 0, minutesAgo minutes: Double = 0, secondsAgo seconds: Double = 0) -> Date {
        let hoursPerDay: Double = 24
        let hoursMeasurement = Measurement(value: (days * hoursPerDay) + hours, unit: UnitDuration.hours)
        let minutesMeasurement = Measurement(value: minutes, unit: UnitDuration.minutes)
        let secondsMeasurement = Measurement(value: seconds, unit: UnitDuration.seconds)
        let totalMeasurement = hoursMeasurement + minutesMeasurement + secondsMeasurement
        let totalTimeInterval = totalMeasurement.converted(to: UnitDuration.seconds).value
        return self - totalTimeInterval
    }
}
