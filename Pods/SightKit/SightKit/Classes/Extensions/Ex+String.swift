//
//  String.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif


public let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? ""

/// 不会暴露给用户看到
public let applicationSupportPath:String = {
    let path:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? ""
    path.createDirectoryIfNotExist() // Library/Application Support 文件夹 默认不存在 需要创建
    return path
}()
    

public func listFilesInDocumentsFolder() -> [String]{
    return (try? FileManager.default.contentsOfDirectory(atPath: documentPath)) ?? []
}
public func listFilesInDir(dir:String) -> [String]{
    return (try? FileManager.default.contentsOfDirectory(atPath: dir)) ?? []
}
public extension String {
    /// 获取文件名在document下的路径
    var pathInDocument:String{
        return documentPath + "/" + self
    }
    
    /// 如果文件在doc下 ，尝试获取其大小
    var fileSizeIfExist:String{
        if let attr = try? FileManager.default.attributesOfItem(atPath: self) {
            let size = Float((attr[FileAttributeKey.size] as! NSNumber).floatValue)
            return String.init(format: "%.2fMB", (size/1024.0)/1024.0)
        }
        return "--MB"
    }
    
    var isDirectory:Bool{
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: self, isDirectory: &isDir) {
            return isDir.boolValue
        }else{//file not exist
            return false
        }
    }
    
    var isFileExist:Bool{
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: self, isDirectory: &isDir) {
            return true
        }else{//file not exist
            return false
        }
    }
    
    @discardableResult func createDirectoryIfNotExist() -> String{
        if (!self.isFileExist){
            try? FileManager.default.createDirectory(atPath: self, withIntermediateDirectories: false, attributes: nil)
        }
        return self
    }
    
    //给文件添加自定义属性
    //https://www.jianshu.com/p/120c91c0871a
}

public extension Optional where Wrapped == String {
    /// guarantee to return a nonil string.(一定返回一个字符串）
    var orEmpty: Wrapped { return self ?? "" }
    
    var isEmpty: Bool { return orEmpty.count == 0 }
}

public extension String {
    func isNewVersion(than compareVersion:String? = nil) -> Bool {
        let localVersion = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "0"
        let targetVersion = compareVersion ?? localVersion
        let result = targetVersion.compare(self, options: .numeric)
        if result == .orderedSame {
            // same version
        } else if result == .orderedAscending {
            // ask user to update
            return true
        } else if result == .orderedDescending {
            // execute if current > appStore
            // don't expect happen...
        }
        return false
    }
}

public extension String {
    
    /// 脱敏处理，手机号（中间四位替换为*） 邮箱保留前两位和@之后的文字，中间替换为*）
    var desensitizeStr : String {
        if self.contains("@"){
            if let str1 = self.components(separatedBy: "@").first,let str2 = self.components(separatedBy: "@").last {
                let str3 = str1.prefix(2)
                return "\(str3)****\(str2)"
            }
        }else {
            if self.count == 11 {
                let str1 = self.prefix(3)
                let str2 = self.suffix(4)
                return "\(str1)****\(str2)"
            }            
        }
        return self
    }
}
public extension String{
    //MARK:- 插入千位逗号
    var withComma : String {
        let array = self.components(separatedBy: ".")
        let bigNum = array.first!
        //转为可变字符串
        let mutableString:NSMutableString = bigNum.mutableCopy() as! NSMutableString
        //获取总长度
        var index:NSInteger = bigNum.count
        //如果总长度 - 3 大于0
        while ((index - 3)) > 0 {
            index -= 3 //存储长度
            mutableString.insert(",", at: index)//插入字符串’,‘
        }
        
        if array.count > 1 {
            let smallNum = array[1]
            let mutableStringSmall:NSMutableString = smallNum.mutableCopy() as! NSMutableString
            //获取总长度
            var index:NSInteger = 0
            //如果总长度 - 3 大于0
            while ((index + 3)) < smallNum.count {
                index += 3 //存储长度
                mutableStringSmall.insert(",", at: index)//插入字符串’,‘
            }
            return (mutableString as String)+"."+(mutableStringSmall as String)
        }
        return mutableString as String
    }
}


// MARK: - string to md5
import CommonCrypto
public extension String {
    ///转为MD5字符串
    var md5Value: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = self.data(using: .utf8) {
            _ = d.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)
                
                return ""
            }
        }
        
        return (0 ..< length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}

// MARK: - base64
public extension String {
    /// base64编码
    var base64Value: String {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return ""
    }
    
    /// base64解码
    var fromBase64Value: String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

// MARK: - 拼音首字母相关
public extension String{
    ///是否包含中文
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars{
            //中文字符范围：0x4e00 ~ 0x9fff
            if (0x4e00 < ch.value && ch.value < 0x9fff){
                return true
            }
        }
        return false
    }
    
    ///这样转换出来的拼音字符串，每个汉字的拼音中间都会用空格隔开，
    func toPinyin() -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false);
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false);
        let pinyin = stringRef as String;
        return pinyin
    }
    
    ///增加去掉空格的汉字拼音
    func toPinyinWithoutBlank() -> String {
        var pinyin = self.toPinyin()
        // 去掉空格
        pinyin = pinyin.replacingOccurrences(of: " ", with: "")
        return pinyin
    }
    
    ///拼音首字母
    func toPinyinHead() -> String {
        // 字符串转换为首字母大写
        let pinyin = self.toPinyin()
        let array = pinyin.components(separatedBy: " ")
        var resultStr = ""
        if array.count > 0 {
            for str in array{
                if str.count>0 {
                    resultStr.append(str.first!)
                }
            }
        }
        return resultStr
    }
}
public extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

// MARK: - 过滤保留
public extension String {
    
    /// 将字符串过滤掉字符串集合以外的任何字符
    ///
    /// - Parameter strSet: 要保留的字符集合
    /// - Returns: 过滤后的字符串
    func keepFromStringSet(strSet:String) -> String {
        let result = String(self.filter { strSet.contains($0) })
        return result
    }
    
    /// 保留英文字母
    func keepLetters() -> String {
        return self.keepFromStringSet(strSet: "abcdefghijklmnopqrstuvwxyzABCDEFGHIGKLMNOPQRSTUVWXYZ")
    }
    
    /// 保留数字
    func keepNumbers() -> String {
        return self.keepFromStringSet(strSet: "0123456789")
    }
    
    /// 保留字母和数字
    func keepLettersNumbers() -> String {
        return self.keepFromStringSet(strSet: "abcdefghijklmnopqrstuvwxyzABCDEFGHIGKLMNOPQRSTUVWXYZ0123456789")
    }
}

// MARK: - 本地化
public var quickSDKSavedLanguageKey = "quickSDKSavedLanguageKey"
/*
 UserDefaults.standard.set("zh-Hans", forKey: savedLanguageKey)
 UserDefaults.standard.synchronize()
 gotoStartVC()

 zh-Hans  //简体中文
 zh-Hant  //繁体中文
 en       //英语
 ko       //韩语
 */
public extension String {
    /// 本地化 未设置过 quickSDKSavedLanguageKey ，取系统语言，否则取上次选择保存的语言
    func localized(bundle: Bundle = .main, tableName: String = "Localize") -> String {
        if let lang = UserDefaults.standard.string(forKey: quickSDKSavedLanguageKey){
            if let path = Bundle.main.path(forResource: lang, ofType: "lproj"){
                return Bundle.init(path: path)?.localizedString(forKey: self, value: "**\(self)**", table: tableName) ?? ""
            }
        }
        
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

public extension String {
    /// 多个字符串作为分隔符
    func components(separatedByStrings strs: [String]) -> [String] {
        var array:[String] = [String.init(format: "%@", self)]
        for key in strs {
            var tmpArray = [String]()
            tmpArray.append(contentsOf: array)
            for value in tmpArray{
                let str = value
                if let existIndex = array.firstIndex(of: value){
                    array.remove(at: existIndex)
                }
                str.components(separatedBy: key).forEach { (element) in
                    if str.count > 0 {
                        array.append(element)
                    }
                }
            }
        }
        return array
    }
}

#if os(iOS)

// MARK: - string to image、imageview、button
public extension String{
    ///转为UIImage
    func toImg(edge: UIEdgeInsets? = nil) -> UIImage? {
        //优先寻找2倍资源 然后1倍资源 然后3倍资源 优先jpg 然后png
        var path = Bundle.main.path(forResource: self+"@2x", ofType: "jpg", inDirectory: nil)
        if path == nil{ path = Bundle.main.path(forResource: self+"@2x", ofType: "png", inDirectory: nil) }
        if path == nil{ path = Bundle.main.path(forResource: self+"", ofType: "jpg", inDirectory: nil) }
        if path == nil{ path = Bundle.main.path(forResource: self+"", ofType: "png", inDirectory: nil) }
        if path == nil{ path = Bundle.main.path(forResource: self+"@3x", ofType: "jpg", inDirectory: nil) }
        if path == nil{ path = Bundle.main.path(forResource: self+"@3x", ofType: "png", inDirectory: nil) }
        
        if let path = path{
            var img = UIImage(contentsOfFile: path)//优先资源文件 然后 asset
            if let edge = edge {
                //指定一个距离上左下右的区域 用来在两个方向上拉伸复制
                img = img?.resizableImage(withCapInsets: edge, resizingMode: .stretch)
            }
            return img
        }
        
        //实在找不到 尝试在asset里找
        return UIImage(named: self)
    }
    ///转为UIImageView
    func toImgView() -> UIImageView {
        let imgView = UIImageView()
        let img = self.toImg()
        imgView.image = img
        return imgView
    }
    ///转为UIButton
    func toBtn() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(self.toImg(), for: .normal)
        return btn
    }
}

// MARK: - 二维码
public extension String {
//    func toQRcodeImg() -> UIImage? {
//        let data = self.data(using: String.Encoding.ascii)
//
//        if let filter = CIFilter(name: "CIQRCodeGenerator") {
//            filter.setValue(data, forKey: "inputMessage")
//            let transform = CGAffineTransform(scaleX: 3, y: 3)
//
//            if let output = filter.outputImage?.transformed(by: transform) {
//                return UIImage(ciImage: output)
//            }
//        }
//
//        return nil
//    }
    
    func toQRcodeImg(imageWidth: CGFloat? = 300, logo: UIImage? = nil) -> UIImage {
        //创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        
        // 恢复滤镜的默认属性
        qrFilter?.setDefaults()
        
        // 将字符串转换成
        let infoData =  self.data(using: .utf8)
        
        // 通过KVC设置滤镜inputMessage数据
        qrFilter?.setValue(infoData, forKey: "inputMessage")
        
        // 获得滤镜输出的图像
        let  outputImage = qrFilter?.outputImage
        
        // 设置缩放比例
        let scale = imageWidth! / outputImage!.extent.size.width;
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage = qrFilter!.outputImage!.transformed(by: transform)
        
        // 获取Image
        let image = UIImage(ciImage: transformImage)
        
        // 无logo时  返回普通二维码image
        guard let QRCodeLogo = logo else { return image }
        
        // logo尺寸与frame
        let logoWidth = image.size.width/4
        let logoFrame = CGRect(x: (image.size.width - logoWidth) /  2, y: (image.size.width - logoWidth) / 2, width: logoWidth, height: logoWidth)
        
        // 绘制二维码
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // 绘制中间logo
        QRCodeLogo.draw(in: logoFrame)
        
        //返回带有logo的二维码
        let QRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return QRCodeImage!
    }
}


public extension String {
    /// Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".containEmoji -> true
    ///
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680...0x1F6FF, // Transport and Map
                 0x1F1E6...0x1F1FF, // Regional country flags
                 0x2600...0x26FF, // Misc symbols
                 0x2700...0x27BF, // Dingbats
                 0xE0020...0xE007F, // Tags
                 0xFE00...0xFE0F, // Variation Selectors
                 0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                 127_000...127_600, // Various asian characters
                 65024...65039, // Variation selector
                 9100...9300, // Misc items
                 8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }

    /// Check if string contains one or more letters.
    ///
    ///        "123abc".hasLetters -> true
    ///        "123".hasLetters -> false
    ///
    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// Check if string contains one or more numbers.
    ///
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    ///
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    /// Check if string contains only letters.
    ///
    ///        "abc".isAlphabetic -> true
    ///        "123abc".isAlphabetic -> false
    ///
    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    /// Check if string contains at least one letter and one number.
    ///
    ///        // useful for passwords
    ///        "123abc".isAlphaNumeric -> true
    ///        "abc".isAlphaNumeric -> false
    ///
    var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }

    ///  Check if string is valid email format.
    ///
    /// - Note: Note that this property does not validate the email address against an email server. It merely attempts to determine whether its format is suitable for an email address.
    ///
    ///        "john@doe.com".isValidEmail -> true
    ///
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// Check if string is a valid URL.
    ///
    ///        "https://google.com".isValidUrl -> true
    ///
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
}


// MARK: - number convert
extension String {
    var hexaToInt      : Int    { return Int(strtoul(self, nil, 16))      }
    var hexaToDouble   : Double { return Double(strtoul(self, nil, 16))   }
    var hexaToBinary   : String { return String(hexaToInt, radix: 2)      }
    var decimalToHexa  : String { return String(Int(self) ?? 0, radix: 16)}
    var decimalToBinary: String { return String(Int(self) ?? 0, radix: 2) }
    var binaryToInt    : Int    { return Int(strtoul(self, nil, 2))       }
    var binaryToDouble : Double { return Double(strtoul(self, nil, 2))   }
    var binaryToHexa   : String { return String(binaryToInt, radix: 16)  }
}

extension Int {
    var binaryString: String { return String(self, radix: 2)  }
    var hexaString  : String { return String(self, radix: 16) }
    var doubleValue : Double { return Double(self) }
}
/*
 "ff".hexaToInt              // "255"
 "ff".hexaToDouble           // "255.0"
 "ff".hexaToBinary           // "11111111"
 "255".decimalToHexa         // "ff"
 "255".decimalToBinary       // "11111111"
 "11111111".binaryToInt      // "255"
 "11111111".binaryToDouble   // "255.0"
 "11111111".binaryToHexa     // "ff"
 255.binaryString            // "11111111"
 255.hexaString              // "ff"
 255.doubleValue             // 255.0 
 */
#endif
