//
//  NSArray.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation


public extension Array where Element: Equatable {
    
    /// 移除某个元素
    /// let array = ["foo", "bar"]
    /// array.remove(element: "foo")
    /// array //=> ["bar"]
    @discardableResult
    mutating func remove(element: Element) -> Index? {
        guard let index = firstIndex(of: element) else { return nil }
        remove(at: index)
        return index
    }
    
    /// 移除多个元素
    @discardableResult
    mutating func remove(elements: [Element]) -> [Index] {
        return elements.compactMap { remove(element: $0) }
    }
}


public extension Array where Element: Hashable {
    /// 去除重复的元素
    mutating func unify() {
        self = unified()
    }
}

public extension Collection where Element: Hashable {
    func unified() -> [Element] {
        return Array(Set(self))
    }
}
