//
//  Int+Helper.swift
//  SwiftTemplet
//
//  Created by dev on 2018/12/11.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

public extension Int{
    /// 偶数
    var isEven: Bool     {  return (self % 2 == 0)  }
    /// 奇数
    var isOdd: Bool      {  return (self % 2 != 0)  }
    /// 大于0
    var isPositive: Bool {  return (self > 0)   }
    /// 小于0
    var isNegative: Bool {  return (self < 0)   }
    /// 转为Double类型
    var toDouble: Double {  return Double(self) }
    /// 转为Float类型
    var toFloat: Float   {  return Float(self)  }
    /// 转为CGFloat类型
    var toCGFloat: CGFloat   {  return CGFloat(self)  }
    /// 转为String类型
    var toString: String { return NSNumber(integerLiteral: self).stringValue; }
    /// 转为NSNumber类型
    var toNumber: NSNumber { return NSNumber(integerLiteral: self); }
    
    var digits: Int {
        if (self == 0) {
            return 1
        }
//        if(Int(fabs(Double(self))) <= LONG_MAX){
        return Int(log10(fabs(Double(self)))) + 1
//        }
    }
    
    static var randomCGFloat: CGFloat { return CGFloat(arc4random()) / CGFloat(UInt32.max) }
    static var random: Int { return Int(arc4random()) / Int(UInt32.max) }

    ///返回重复值字符串
    func repeatString(_ repeatedValue: String) ->String{
        return String(repeating: repeatedValue, count: self)
    }
    ///返回重复值数组
    func repeatArray<T>(_ repeatedValue: T) -> [T] {
        return [T](repeating: repeatedValue, count: self)
    }
        
}

public extension Double{
    
    /// 转为String类型
    var toString: String { return NSNumber(floatLiteral: self).stringValue; }
    /// 转为NSNumber类型
    var toNumber: NSNumber { return NSNumber(floatLiteral: self); }
    
    /// 保留n为小数
    func roundedTo(_ n: Int) -> Double {
        let divisor = pow(10.0, Double(n))
        let result = (self * divisor).rounded() / divisor
        return result
    }
}



