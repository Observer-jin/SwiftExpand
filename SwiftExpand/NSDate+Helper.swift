//
//  Date+Helper.swift
//  SwiftTemplet
//
//  Created by dev on 2018/12/11.
//  Copyright © 2018年 BN. All rights reserved.
//
/*
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 */

import UIKit

/// 60s
public let kDate_minute : Double = 60 ;
/// 3600s
public let kDate_hour : Double   = 3600 ;
/// 86400
public let kDate_day : Double    = 86400 ;
/// 604800
public let kDate_week : Double   = 604800 ;
/// 31556926
public let kDate_year : Double   = 31556926 ;


/// yyyy-MM-dd HH:mm:ss(默认)
public let kDateFormat             = "yyyy-MM-dd HH:mm:ss";
/// yyyy-MM
public let kDateFormat_month       = "yyyy-MM";
/// yyyy-MM-dd
public let kDateFormat_day         = "yyyy-MM-dd";
/// yyyy-MM-dd HH
public let kDateFormat_hour        = "yyyy-MM-dd HH";
/// yyyy-MM-dd HH:mm
public let kDateFormat_minute      = "yyyy-MM-dd HH:mm";
/// yyyy-MM-dd HH:mm:ss eee
public let kDateFormat_millisecond = "yyyy-MM-dd HH:mm:ss eee";
/// yyyy-MM-dd 00:00:00
public let kDateFormat_start       = "yyyy-MM-dd 00:00:00";
/// yyyy-MM-dd 23:59:59
public let kDateFormat_end         = "yyyy-MM-dd 23:59:59";

/// yyyy年M月
public let kDateFormat_month_ch    = "yyyy年MM月";
/// yyyy年MM月dd日
public let kDateFormat_day_ch      = "yyyy年MM月dd日";
/// yyyyMMdd
public let kDateFormat_two         = "yyyyMMdd";


extension DateFormatter{
    
    /// 获取DateFormatter(默认格式)
    @objc public static func format(_ formatStr: String = kDateFormat) -> DateFormatter {
        let dic = Thread.current.threadDictionary;
        if dic.object(forKey: formatStr) != nil {
            return dic.object(forKey: formatStr) as! DateFormatter;
        }
        
        let fmt = DateFormatter();
        fmt.dateFormat = formatStr;
        fmt.locale = .current;
        fmt.locale = Locale(identifier: "zh_CN");
        fmt.timeZone = formatStr.contains("GMT") ? TimeZone(identifier: "GMT") : TimeZone.current;
        
        dic.setObject(fmt, forKey: formatStr as NSCopying)
        return fmt;
    }
    
    /// Date -> String
    @objc public static func stringFromDate(_ date: Date, fmt: String = kDateFormat) -> String {
        let formatter = DateFormatter.format(fmt);
        return formatter.string(from: date);
    }
    
    /// String -> Date
    @objc public static func dateFromString(_ dateStr: String, fmt: String = kDateFormat) -> Date {
        let formatter = DateFormatter.format(fmt);
        return formatter.date(from: dateStr)!;
    }
    
    /// 时间戳字符串 -> 日期字符串
    @objc public static func stringFromInterval(_ interval: String, fmt: String = kDateFormat) -> String {
        let date = Date(timeIntervalSince1970: interval.doubleValue())
        return DateFormatter.stringFromDate(date, fmt: fmt);
    }

    /// 日期字符串 -> 时间戳字符串
    @objc public static func IntervalFromDateStr(_ dateStr: String, fmt: String = kDateFormat) -> String {
        let date = DateFormatter.dateFromString(dateStr, fmt: fmt)
        return "\(date.timeIntervalSince1970)";
    }
    
    /// 日期字符串和fmt是同种格式
    @objc public static func isSameFormat(_ dateStr: String, fmt: String = kDateFormat) -> Bool {
        
        if dateStr.count == fmt.count {
            let str: NSString = dateStr as NSString
            let format: NSString = fmt as NSString

            if str.length >= 17 {
                let char4 = str.substring(with: NSRange(location: 4, length: 1))
                let char7 = str.substring(with: NSRange(location: 7, length: 1))
                let char13 = str.substring(with: NSRange(location: 13, length: 1))
                let char16 = str.substring(with: NSRange(location: 16, length: 1))
              
                let format4 = format.substring(with: NSRange(location: 4, length: 1))
                let format7 = format.substring(with: NSRange(location: 7, length: 1))
                let format13 = format.substring(with: NSRange(location: 13, length: 1))
                let format16 = format.substring(with: NSRange(location: 16, length: 1))
                
                let isSame = (char4 == format4 && char7 == format7 && char13 == format13 && char16 == format16)
                return isSame;
            }
            
            if str.length >= 14 {
                let char4 = str.substring(with: NSRange(location: 4, length: 1))
                let char7 = str.substring(with: NSRange(location: 7, length: 1))
                let char13 = str.substring(with: NSRange(location: 13, length: 1))
                
                let format4 = format.substring(with: NSRange(location: 4, length: 1))
                let format7 = format.substring(with: NSRange(location: 7, length: 1))
                let format13 = format.substring(with: NSRange(location: 13, length: 1))
                
                let isSame = (char4 == format4  && char7 == format7 && char13 == format13)
                return isSame;
            }
           
            if str.length >= 8 {
                let char4 = str.substring(with: NSRange(location: 4, length: 1))
                let char7 = str.substring(with: NSRange(location: 7, length: 1))
               
                let format4 = format.substring(with: NSRange(location: 4, length: 1))
                let format7 = format.substring(with: NSRange(location: 7, length: 1))
                
                let isSame = (char4 == format4  && char7 == format7)
                return isSame;
            } else if str.length >= 5 {
                let char4 = str.substring(with: NSRange(location: 4, length: 1))
                
                let format4 = format.substring(with: NSRange(location: 4, length: 1))
                
                let isSame = (char4 == format4)
                return isSame;
            }
        }
        return false
    }
    
}

extension Date{
    public static var calendar: Calendar = Calendar(identifier: .gregorian)

    public func string(formatStr: String) -> String{
        let formatter = DateFormatter.format(formatStr);
        let dateStr = formatter.string(from: self as Date);
        return dateStr;
    }
    
    /// 现在时间上添加天数(负数:之前时间, 正数: 将来时间)
    public func addingDays(_ days: Int, hour: Int, minute: Int, second: Int) -> Date{
        let date: Date = addingTimeInterval(TimeInterval(days*24*3600 + hour*3600 + minute*60 + second))
        return date;
    }
    
    /// 现在时间上添加天数(负数:之前时间, 正数: 将来时间)
    public func addingDays(_ days: Int) -> Date{
        let date: Date = addingTimeInterval(TimeInterval(days*24*3600))
        return date;
    }
    
    /// 多少天之前
    public func addingDays(_ days: Int, fmt: String = kDateFormat) -> String{
        let newDate = addingDays(-days);
        return newDate.string(formatStr: fmt);
    }
    
    public func agoInfo() -> String {
        var interval = Date().timeIntervalSinceNow - self.timeIntervalSinceNow

        var info = "\(Int(interval/kDate_day))" + "天"
        interval = interval.truncatingRemainder(dividingBy: kDate_day);
        
        info += "\(Int(interval/kDate_hour))" + "小时"
        interval = interval.truncatingRemainder(dividingBy: kDate_hour);
        
        info += "\(Int(interval/kDate_minute))" + "分钟"
        interval = interval.truncatingRemainder(dividingBy: kDate_minute);
        
        info += "\(Int(interval))" + "秒之前"
        return info;
    }
    
    public func hourInfoBetween(_ date: Date,_ type: Int = 0) -> Double {
        var diff = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        switch type {
            case 1://分钟
                diff = fabs(diff/60)

            case 2://小时
                diff = fabs(diff/3600)

            case 3://天
                diff = fabs(diff/86400)

            default://秒
                diff = fabs(diff)
        }
        return diff;
    }
    
    public func daysInBetween(_ date: Date) -> Double {
        return hourInfoBetween(date, 3)
    }
    
    public func hoursInBetween(_ date: Date) -> Double {
        return hourInfoBetween(date, 2)
    }
    
    public func minutesInBetween(_ date: Date) -> Double {
        return hourInfoBetween(date, 1)
    }
    
    public func secondsInBetween(_ date: Date) -> Double {
        return hourInfoBetween(date, 0)
    }
    
    //MARK: - 获取日期各种值
    
    /// 获取默认DateComponents[年月日]
    public static func dateComponents(_ aDate: Date) -> DateComponents {
        let com = Date.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: aDate)
        return com
    }
    
    /// 两个时间差的NSDateComponents
    public static func dateFrom(_ aDate: Date, anotherDate: Date) -> DateComponents {
        let com = Date.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: aDate, to: anotherDate)
        return com
    }
    
    ///包含2个日期的年/月/日/时/分/秒数量
    static func numDateFrom(_ aDate: Date, anotherDate: Date, type: Int = 0) -> Int {
        let comp = Date.dateComponents(aDate)
        let comp1 = Date.dateComponents(anotherDate)

        var number = comp1.year! - comp.year! + 1;
        switch type {
        case 1:
            number = comp1.month! - comp.month! + 1;
            
        case 2:
            number = comp1.day! - comp.day! + 1;

        case 3:
            number = comp1.hour! - comp.hour! + 1;

        case 4:
            number = comp1.minute! - comp.minute! + 1;

        case 5:
            number = comp1.second! - comp.second! + 1;

        default:
            break;
        }
        return number
    }
    
    //MARK: 年
    public func year() ->Int {
        return Date.dateComponents(self).year!
    }
    //MARK: 月
    public func month() ->Int {
        return Date.dateComponents(self).month!
    }
    //MARK: 日
    public func day() ->Int {
        return Date.dateComponents(self).day!;
    }
    
    //MARK: 一周的第几天
    public static func weekDay(_ comp: DateComponents) ->Int{
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let newDate = Date.calendar.date(from: comp)
        let weekDay = Date.calendar.component(.weekday, from: newDate!)
        return weekDay
    }
    
    //MARK: 当月天数
    public func countOfDaysInMonth() ->Int {
        let calendar = Date.calendar
        let range = (calendar as NSCalendar?)?.range(of: .day, in: .month, for: self)
        return range!.length
//        let range = Date.calendar.range(of: .day, in: .month, for: aDate);
//        return range!.upperBound - range!.lowerBound
    }
    //MARK: 当月第一天是星期几
    public func firstWeekDay() ->Int {
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        var comp: DateComponents = Date.dateComponents(self)
        comp.day = 1
        
        let firstWeekDay = Date.weekDay(comp)
        return firstWeekDay
//        let firstWeekDay = Date.calendar.ordinality(of: .weekday, in: .weekOfMonth, for: self)
//        return firstWeekDay! - 1
    }
    //MARK: - 日期的一些比较
    /// 两个时间同年0;同月1;同日2;同时3;同分4;同秒5
    public static func isSameFrom(_ aDate: Date, anotherDate: Date, type: Int = 0) -> Bool {
        let comp = Date.dateComponents(aDate)
        let comp1 = Date.dateComponents(anotherDate)
        
        var isSame = (comp1.year == comp.year);
        switch type {
        case 1:
            isSame = (comp1.year == comp.year && comp1.month == comp.month);
            
        case 2:
            isSame = (comp1.year == comp.year && comp1.month == comp.month && comp1.day == comp.day);
            
        case 3:
            isSame = (comp1.year == comp.year && comp1.month == comp.month && comp1.day == comp.day && comp1.hour == comp.hour);
            
        case 4:
            isSame = (comp1.year == comp.year && comp1.month == comp.month && comp1.day == comp.day && comp1.hour == comp.hour && comp1.minute == comp.minute);
            
        case 5:
            isSame = (comp1.year == comp.year && comp1.month == comp.month && comp1.day == comp.day && comp1.hour == comp.hour && comp1.second == comp.second);
            
        default:
            break;
        }
        return isSame
    }
    //是否是今天
    public func isToday() ->Bool {
        return Date.isSameFrom(self, anotherDate: Date(), type: 2)
    }
    //是否是这个月
    public func isThisMonth() ->Bool {
        return Date.isSameFrom(self, anotherDate: Date(), type: 1)
    }
 
    public func isThisYear() ->Bool {
        return Date.isSameFrom(self, anotherDate: Date(), type: 0)
    }
    
    /// DateComponents(年月日时分秒)
    public static func components(_ year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) ->DateComponents{
        return DateComponents(calendar: Date.calendar, timeZone: nil, era: nil, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    }
    
    
}


extension NSDate{
    /// 现在时间上添加天数(负数:之前时间, 正数: 将来时间)
    @objc public func adding(_ days: Int, hour: Int, minute: Int, second: Int) -> NSDate{
        let date: NSDate = addingTimeInterval(TimeInterval(days*24*3600 + hour*3600 + minute*60 + second))
        return date;
    }
}
