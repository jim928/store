//
//  Ex+Float.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation

public var adaptBaseValue:CGFloat = 375
public extension Optional {
    /// 可选值为空的时候返回 true
    var isNone: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
    
    /// 可选值非空返回 true
    var isSome: Bool {
        return !isNone
    }
}

public extension Int {
    var str:String {
        return "\(self)"
    }
    var float:Float {
        return Float(self)
    }
    var cgfloat:CGFloat {
        return CGFloat(self)
    }
    
    /// 除之后取整，计算UI顶距用
    func slots(num:Int) -> CGFloat {
        return CGFloat(Int(self/num))
//        return CGFloat(Int(self/num) + (self%num == 0 ? 0 : 1))
    }
    
    /// 以375宽度为设计模板计算适配值
    var adapt:CGFloat {
        return CGFloat(self)*ScreenWidth/adaptBaseValue
    }
}

public extension Double {
    var str:String {
        return "\(self)"
    }
    var float:Float {
        return Float(self)
    }
    var cgfloat:CGFloat {
        return CGFloat(self)
    }
    
    /// 以375宽度为设计模板计算适配值
    var adapt:CGFloat {
        return CGFloat(self)*ScreenWidth/adaptBaseValue
    }
}

public extension CGFloat {
    /// 以375宽度为设计模板计算适配值
    var adapt:CGFloat {
        return CGFloat(self)*ScreenWidth/adaptBaseValue
    }
    
}

public extension Float {
    /// 转为百分比字符串
    var percentStr:String {
        return String.init(format: "%.2f%%", self*100)
    }
    
    var str:String {
        return "\(self)"
    }
    var int:Int {
        return Int(self)
    }
    
    /// 如果参数是小数  则求本身的四舍五入.
    var round:Float{
        return roundf(self)
    }
    /// 如果参数是小数  则求最小的整数但不小于本身.
    var ceil:Float{
        return ceilf(self)
    }
    /// 如果参数是小数  则求最大的整数但不大于本身.
    var floor:Float{
        return floorf(self)
    }
    var cgfloat:CGFloat{
        return CGFloat(self)
    }
}

public extension Optional {
    /// 尝试将Int Float转成字符串
    var str: String {
        if let value = self {
            return "\(value)"
        }
        return ""
    }
    /// 将float? 值 转成 x%格式的字符串
    var percentStr: String {
        if let value = Float(self.str) {
            return String(format: "%.2f", value*100.0)+"%"
        }
        return self.str
    }
}
public extension Optional where Wrapped == Data {
    /// guarantee to return a data
    var orEmpty: Wrapped { return self ?? Data() }
}
public extension Optional where Wrapped: ExpressibleByIntegerLiteral {
    /// guarantee to return a numerical value
    var orZero: Wrapped { return self ?? 0 }
}

public extension Optional where Wrapped: ExpressibleByBooleanLiteral {
    /// guarantee to return a bool value
    var orFalse: Wrapped { return self ?? false }
}

public extension Optional where Wrapped: Collection {
    /// 无法区分Array 和 Dictionary ，待解决
//    var orEmpty: Wrapped {
//        return self ?? [:] as! Wrapped
//        return self ?? [] as! Wrapped
//    }
}

public extension BinaryFloatingPoint {

    #if canImport(Foundation)
    /// SwifterSwift: Returns a rounded value with the specified number of
    /// decimal places and rounding rule. If `numberOfDecimalPlaces` is negative,
    /// `0` will be used.
    ///
    ///     let num = 3.1415927
    ///     num.rounded(numberOfDecimalPlaces: 3, rule: .up) -> 3.142
    ///     num.rounded(numberOfDecimalPlaces: 3, rule: .down) -> 3.141
    ///     num.rounded(numberOfDecimalPlaces: 2, rule: .awayFromZero) -> 3.15
    ///     num.rounded(numberOfDecimalPlaces: 4, rule: .towardZero) -> 3.1415
    ///     num.rounded(numberOfDecimalPlaces: -1, rule: .toNearestOrEven) -> 3
    ///
    /// - Parameters:
    ///   - numberOfDecimalPlaces: The expected number of decimal places.
    ///   - rule: The rounding rule to use.
    /// - Returns: The rounded value.
    func rounded(numberOfDecimalPlaces: Int, rule: FloatingPointRoundingRule) -> Self {
        let factor = Self(pow(10.0, Double(max(0, numberOfDecimalPlaces))))
        return (self * factor).rounded(rule) / factor
    }
    #endif

}
