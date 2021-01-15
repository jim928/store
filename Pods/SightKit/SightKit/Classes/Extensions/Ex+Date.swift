//
//  Et+Date.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation


public enum TimeFormat:String
{
    
    /// yyyy-MM-dd HH:mm:ss
    case yyyy_MM_ddHHmmss       = "yyyy-MM-dd HH:mm:ss"
    
    /// yy-MM-dd HH:mm
    case yy_MM_ddHHmm           = "yy-MM-dd HH:mm"
    
    /// yyyy-MM-dd HH:mm
    case yyyy_MM_ddHHmm         = "yyyy-MM-dd HH:mm"
    
    /// yyyy-MM-dd
    case yyyy_MM_dd             = "yyyy-MM-dd"
    
    /// MM-dd HH:mm:ss
    case MM_ddHHmmss            = "MM-dd HH:mm:ss"
    
    /// MM-dd HH:mm
    case MM_ddHHmm              = "MM-dd HH:mm"
    
    /// HH:mm:ss
    case HHmmss                 = "HH:mm:ss"
    
    /// HH:mm
    case HHmm                   = "HH:mm"
    
    /// MM-dd
    case MM_dd                  = "MM-dd"
    
    /// yy-MM-dd
    case yy_MM_dd               = "yy-MM-dd"
    
    /// yyyyMMdd
    case yyyyMMdd               = "yyyyMMdd"
    
    /// yyyyMMddHHmmss
    case yyyyMMddHHmmss         = "yyyyMMddHHmmss"
    
    /// yyyy-MM-dd HH:mm:ss.SSS
    case yyyy_MM_ddHHmmssSSS    = "yyyy-MM-dd HH:mm:ss.SSS"
    
    /// yyyyMMddHHmmssSSS
    case yyyyMMddHHmmssSSS      = "yyyyMMddHHmmssSSS"
    
    /// yyyy/MM/dd
    case yyyyMMddSlash          = "yyyy/MM/dd"
    
    /// yyyy-MM
    case yyyy_MM                = "yyyy-MM"
    
    /// yyyy.MM.dd
    case yyyyMMddDot            = "yyyy.MM.dd"
}
 

public extension Int {
    var date:Date {
        let timeInterval:TimeInterval = TimeInterval(self)
        let date = Date.init(timeIntervalSince1970: timeInterval/1000)
        return date
    }
}

/// 精确到秒的时间 yyyy.MM.dd HH:mm:ss
public func timeDesFromUnixtime(str:String?) -> String {
    guard let timeStr = str else { return "" }
    guard let timeInterval:TimeInterval = TimeInterval(timeStr) else { return "" }
    let date = Date.init(timeIntervalSince1970: timeInterval/1000)
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy.MM.dd HH:mm:ss" //自定义日期格式
    let time = dateformatter.string(from: date)
    
    return time
}

/// 精确到天的时间 yyyy.MM.dd
public func dayDesFromUnixtime(str:String?) -> String {
    guard let timeStr = str else { return "" }
    guard let timeInterval:TimeInterval = TimeInterval(timeStr) else { return "" }
    let date = Date.init(timeIntervalSince1970: timeInterval/1000)
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy.MM.dd" //自定义日期格式
    let time = dateformatter.string(from: date)
    
    return time
}

/// 精确到毫秒的当前时间戳
public var currentUnixTimeMinisecStr:String{
    get {
        let timeInterval = Date().timeIntervalSince1970
        let str = String(format: "%.0f", timeInterval*1000)
        return str
    }
}
/// 精确到秒的当前时间戳
public var currentUnixTimeSecStr:String{
    get {
        let timeInterval = Date().timeIntervalSince1970
        let str = String(format: "%.0f", timeInterval*1000)
        return str
    }
}

public extension Date {
    
    /// 两个日期中间有几天
    func days(between otherDate: Date) -> Int {
        let calendar = Calendar.current
        
        let startOfSelf = calendar.startOfDay(for: self)
        let startOfOther = calendar.startOfDay(for: otherDate)
        let components = calendar.dateComponents([.day], from: startOfSelf, to: startOfOther)
        
        return abs(components.day ?? 0)
    }
}

// MARK: - 日期
public extension Date{
    func stringWith(format:TimeFormat) -> String{
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = format.rawValue
        let str = dateFormate.string(from: self)
        return str
    }
    
    ///日期字符串 yyyy-MM-dd HH:mm:ss
    var string:String{
        get {
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let str = dateFormate.string(from: self)
            return str
        }
    }
    
    /// 日期字符串 yyyy-MM-dd HH:mm:ss.SSS
    var stringWithMinsecond:String{
        get {
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let str = dateFormate.string(from: self)
            return str
        }
    }
    
    /// 年份 yyyy
    var year:String{
        get {
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "yyyy"
            let str = dateFormate.string(from: self)
            return str
        }
    }
    
    /// 月份 MM
    var month:String{
        get {
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "MM"
            let str = dateFormate.string(from: self)
            return str
        }
    }
    
    /// 天 dd
    var day:String{
        get {
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd"
            let str = dateFormate.string(from: self)
            return str
        }
    }
}

/// 根据后台时间戳 转换为 几分钟前，几小时前，几天前
public func currentTimeDes(timeStampStr: String) -> String {
    guard let timeStamp = Double(timeStampStr) else { return "" }
    
    //获取当前的时间戳
    let currentTime = Date().timeIntervalSince1970
    //    print(currentTime,   timeStamp, "sdsss")
    //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
    let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
    //时间差
    let reduceTime : TimeInterval = currentTime - timeSta
    //时间差小于60秒
    if reduceTime < 60 {
        return "刚刚"
    }
    //时间差大于一分钟小于60分钟内
    let mins = Int(reduceTime / 60)
    if mins < 60 {
        return "\(mins)分钟前"
    }
    let hours = Int(reduceTime / 3600)
    if hours < 24 {
        return "\(hours)小时前"
    }
    let days = Int(reduceTime / 3600 / 24)
    if days < 30 {
        return "\(days)天前"
    }
    //不满足上述条件---或者是未来日期-----直接返回日期
    let date = NSDate(timeIntervalSince1970: timeSta)
    let dfmatter = DateFormatter()
    //yyyy-MM-dd HH:mm:ss
    dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
    return dfmatter.string(from: date as Date)
}

public extension Date {
    /// 日期这一天的0点0分0秒
    var today:Date{
        get {
            let calendar:NSCalendar = NSCalendar.current as NSCalendar
            let unitFlags: NSCalendar.Unit = [
                NSCalendar.Unit.year,
                NSCalendar.Unit.month,
                NSCalendar.Unit.day,
                .hour,
                .minute,
                .second ]
            //calendar.components(unitFlags, fromDate: self)//解析当前的时间 返回NSDateComponents 解析后的数据后面设置解析后的时间在反转
            var components = calendar.components(unitFlags, from: self as Date)
            components.hour = 0
            components.minute = 0
            components.second = 0
            let date = calendar.date(from: components)
            
            return date!
        }
    }
    
    /// 日期所在周的周一 0点0分0秒
    var monday:Date {
        get {
            let nowDate = self
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: nowDate)
            
            // 获取今天是周几
            let weekDay = comp.weekday
            // 获取几天是几号
            let day = comp.day
            
            // 计算当前日期和本周的星期一相差天数
            var firstDiff: Int
            // weekDay = 1;
            if (weekDay == 1) {
                firstDiff = -6;
            } else {
                firstDiff = calendar.firstWeekday - weekDay! + 1
            }
            
            // 在当前日期(去掉时分秒)基础上加上差的天数
            var firstDayComp = calendar.dateComponents([.year, .month, .day], from: nowDate)
            firstDayComp.day = day! + firstDiff
            let firstDayOfWeek = calendar.date(from: firstDayComp)
            
            return firstDayOfWeek!;
        }
    }
    
    /// 日期所在周的周日 0点0分0秒
    var sunday:Date {
        get {
            let nowDate = self
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: nowDate)
            
            // 获取今天是周几
            let weekDay = comp.weekday
            // 获取几天是几号
            let day = comp.day
            
            // 计算当前日期和本周的星期天相差天数
            var lastDiff: Int
            // weekDay = 1;
            if (weekDay == 1) {
                lastDiff = 0;
            } else {
                lastDiff = 8 - weekDay!
            }
            
            // 在当前日期(去掉时分秒)基础上加上差的天数
            var lastDayComp = calendar.dateComponents([.year, .month, .day], from: nowDate)
            lastDayComp.day = day! + lastDiff
            let lastDayOfWeek = calendar.date(from: lastDayComp)
            
            return lastDayOfWeek!;
        }
    }
    
    /// 日期所在月的第一天
    var firstDayOfMonth:Date {
        get {
            let nowDayDate = self
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: nowDayDate)
            let startOfMonth = calendar.date(from: components)
            
            return startOfMonth!
        }
    }
}
