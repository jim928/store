//
//  Ex+UIColor.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation
/** rgb字符串转UIColor，如果格式错误 会使用颜色 #999999
 ## 使用示例
 ```
 rgb("ED2343")
 rgb("ED2343",0.8)
 */
public func rgb(_ hex:String,_ alpha:Float = 1.0) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) == 6) {
        Scanner(string: cString).scanHexInt32(&rgbValue)
    }

    let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
    let b = CGFloat(rgbValue & 0x0000FF) / 255.0
    return UIColor.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
}

public extension String {
    var toColor:UIColor{
        get {
            return rgb(self)
        }
    }
}

public extension UIColor {
    func wAlpha(_ alpha:Float) -> UIColor {
        return self.withAlphaComponent(CGFloat(alpha))
    }
}

public extension UIColor {
    /// 十六进制创建颜色
    convenience init(hex: Int, alpha: Double = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}

public extension UIColor {
    /// 颜色转为 UIImage
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

