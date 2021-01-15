//
//  Ex+Data.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation


public extension Data {
    /// 保存data为文件
    /// - Parameter path: 路径，包含文件名
    func saveToPath(path:String){
        FileManager.default.createFile(atPath: path, contents: self, attributes: nil)
    }
    
    static func dataFromPath(path:String) -> Data?{
        if let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)){
            return data
        }
        return nil
    }
}

public extension Data {
    func string(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
}
