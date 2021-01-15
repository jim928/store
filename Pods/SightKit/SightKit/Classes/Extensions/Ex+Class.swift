//
//  Et+Class.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation


public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    /// 获取类名的字符串 举例 UIView.className //"UIView"  UILabel().className //"UILabel"
    var className: String {
        return type(of: self).className
    }
}
extension NSObject: ClassNameProtocol {}
