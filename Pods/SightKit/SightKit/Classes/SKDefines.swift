//
//  SKDefines.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation

public let ScreenWidth = UIScreen.main.bounds.size.width
public let ScreenHeight = UIScreen.main.bounds.size.height

/// 是否是齐刘海iPhone
public var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        // with notch: 44.0 on iPhone X, XS, XS Max, XR.
        // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
    }
    return false
}

public let StatusBarHeight: CGFloat = hasTopNotch ? 44 : 20
public let NavStatusBarHeight: CGFloat = hasTopNotch ? 88 : 64
public let TabbarHeight: CGFloat = hasTopNotch ? 83 : 49
public let BottomExtraHeight: CGFloat = hasTopNotch ? 34 : 0

public func widthForRate(nowH:CGFloat, w:CGFloat,h:CGFloat) -> CGFloat { return w*nowH/h }
public func heightForRate(nowW:CGFloat, w:CGFloat,h:CGFloat) -> CGFloat { return h*nowW/w }

let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad



/// 是否首次安装
public var isAppFirstInstall:Bool {
    let key = "hasCalledThisMethodKey"
    if UserDefaults.standard.bool(forKey: key) {
        return true
    }
    UserDefaults.standard.set(true, forKey: key)
    UserDefaults.standard.synchronize()
    return false
}

///获取APP缓存
func getCacheSize()-> String {
    // 取出cache文件夹目录
    let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    //快速枚举出所有文件名 计算文件大小
    var size = 0
    for file in fileArr! {
        // 把文件名拼接到路径中
        let path = cachePath! + ("/\(file)")
        // 取出文件属性
        let floder = try! FileManager.default.attributesOfItem(atPath: path)
        // 用元组取出文件大小属性
        for (key, fileSize) in floder {
            // 累加文件大小
            if key == FileAttributeKey.size {
                size += (fileSize as AnyObject).integerValue
            }
        }
    }
    let totalCache = Double(size) / 1024.00 / 1024.00
    return String(format: "%.2f", totalCache)
}
///删除APP缓存
func clearCache() {
    // 取出cache文件夹目录
    let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    // 遍历删除
    for file in fileArr! {
        let path = (cachePath! as NSString).appending("/\(file)")
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                
            }
        }
    }
}
