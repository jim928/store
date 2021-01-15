//
//  request.swift
//  SightKit
//
//  Created by 湛奇 on 2020/10/11.
//

import Foundation

public typealias ConfigRqHeadClosure = () -> [String:String]

public enum Local_Error : Error {
    ///url is nil
    case null_url
    ///create URL from string failed
    case invalid_url
    ///create Data frome dictionary failed
    case invalid_paramDic_to_data
    ///create JsonObject frome responseData failed
    case invalid_responseData_to_jsonDic
}

public var api_timeout:TimeInterval = 60

public enum RequestMethod:String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

@objc public class RPHead: NSObject, Codable {
    public let cost:Int64?
    public let errCode:String?
    public let errMsg:String?
}


/// only for error decode
@objc public class RPEmpty: NSObject, Codable {
    public let head:RPHead?
}


/*
 @objc public class RPLoginSuccess: NSObject, Codable {
     public let head:RPHead?
     public let body:RPLoginSuccessBody?
 }
 @objc public class RPLoginSuccessBody: NSObject, Codable {
     public var avatar : String?
     public var customerId : String?
     public var customerType : Int32?
     public var loginName : String?
     public var mobileNo : String?
     public var starLevel : Int32?
     public var starLevelName : String?
     public var token : String?
     public var webInfo : String?
 }
 */

/// every response will pass here ,so we can deal with app level errors
public var appLevelRequestResponse:((_ data:Data?,_ response:URLResponse?,_ error:Error?)->())?

/// open log for normal request result
#if DEBUG
public var openRequestLog = true
#else
public var openRequestLog = false
#endif

public var skSessionConfiguration:URLSessionConfiguration = {
    let config = URLSessionConfiguration.default
    config.httpMaximumConnectionsPerHost = 4
    return config
}()
/*
public func skRq(urlString:String?,method:RequestMethod = .get,paraDic:[String:Any]=[:],configRqHead:ConfigRqHeadClosure? = nil, rpClosure: @escaping (Data?, URLResponse?, Error?) -> Void)  {
    guard let urlString = urlString else {
        print("Error: urlString is null")
        
        DispatchQueue.main.async { rpClosure(nil,nil,Local_Error.null_url) }
        return
    }
    
    var request:URLRequest!
    var finalParaDic = [String:Any]()

    if (method == .get){
        var fixString = ""
        if paraDic.count > 0 {
            fixString.append("?")
            paraDic.forEach { (key: String, value: Any) in
                if (fixString.count>1){
                    fixString.append("&")
                }
                fixString.append(key)
                fixString.append("=")
                fixString.append("\(value)")
            }
        }
        
        let finalStr = urlString+fixString
        guard let url = URL(string: finalStr) else {
            print("Error: cannot create url with urlString:\(urlString)")
            
            DispatchQueue.main.async { rpClosure(nil,nil,Local_Error.invalid_url) }
            return
        }
        
        request = URLRequest(url: url)
        request.timeoutInterval = api_timeout
        request.httpMethod = method.rawValue
        if let headDic = configRqHead?(){
            headDic.forEach { (key,value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

    }else{
        guard let url = URL(string: urlString) else {
            print("Error: cannot create url with urlString:\(urlString)")
            
            DispatchQueue.main.async { rpClosure(nil,nil,Local_Error.invalid_url) }
            return
        }
        
        //先添加需要的数据到finalParaDic
        //然后添加传进来的数据到fainalParaDic
        paraDic.forEach { (key: String, value: Any) in
            finalParaDic[key] = value
        }
        
        request = URLRequest(url: url)
        request.timeoutInterval = api_timeout
        request.httpMethod = method.rawValue
        var jsonData:Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: finalParaDic, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error: cannot creat Json from paraDic \(String(describing: finalParaDic))")
            
            DispatchQueue.main.async { rpClosure(nil,nil,Local_Error.invalid_paramDic_to_data) }
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let headDic = configRqHead?(){
            headDic.forEach { (key,value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    skSessionConfiguration.httpMaximumConnectionsPerHost = 4
    let session = URLSession(configuration: skSessionConfiguration)
    let task = session.dataTask(with: request) { (data, response, error) in
        //for log
        if (openRequestLog){
            print("url:",request.url?.absoluteString ?? "")
            print("headFields:",request.allHTTPHeaderFields ?? "")
            print("param:",finalParaDic)
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data,options:.allowFragments) as? [String: Any]
                print("json:",json ?? "")
                if json == nil {
                    let str = String(data: data, encoding: String.Encoding.utf8) ?? ""
                    print("string:",str)
                }
            }
        }
        if error != nil {
            print("Error: ",error.debugDescription)
        }
        if data == nil && error == nil &&  response != nil {
            print("response:",response.debugDescription)
        }

        //return block
        DispatchQueue.main.async { rpClosure(data,response,error) }
        
        //for app level error handle
        DispatchQueue.main.async {
            if let appLevelRequestResponse = appLevelRequestResponse{
                appLevelRequestResponse(data,response,error)
            }
        }
    }
    task.resume()
}
*/

public func errorTipFrom(head:RPHead?, response: URLResponse?,error:Error?)->String?{
    if error != nil {
        return error?.localizedDescription
    }
    if head != nil {
        if head?.errCode != "0000"{
            return head?.errMsg
        }
    }
    return nil
}


public class SKRq : NSObject{
    public var request:URLRequest?
    public var url:String = ""
    public var param:[String:Any] = [:]
    public var method:String = "GET"
    public var header:[String:String] = [:]
    public static var globalHeader:[String:String] = [:]

    @discardableResult public func wUrl(_ u:String) -> SKRq {
        url = u
        return self
    }
    @discardableResult public func wParam(_ p:[String:Any]) -> SKRq {
        param = p
        return self
    }
    @discardableResult public func wHeader(_ h:[String:String]) -> SKRq {
        header = h
        return self
    }
    
    @discardableResult public func wGet() -> SKRq {
        method = "GET"
        return self
    }
    @discardableResult public func wPost() -> SKRq {
        method = "POST"
        return self
    }
    
    
    @discardableResult public func resume(_ result:@escaping ((SKResult)->Void)) -> SKRq {
        var request:URLRequest!
        var finalParaDic = [String:Any]()

        if (method.lowercased() == "get"){
            var fixString = ""
            if param.count > 0 {
                fixString.append("?")
                param.forEach { (key: String, value: Any) in
                    if (fixString.count>1){
                        fixString.append("&")
                    }
                    fixString.append(key)
                    fixString.append("=")
                    fixString.append("\(value)")
                }
            }
            
            let finalStr = url+fixString
            guard let url = URL(string: finalStr) else {
                print("Error: cannot create url with urlString:\(finalStr)")
                
                DispatchQueue.main.async { result(SKResult(d: nil, r: nil, e: Local_Error.invalid_url)) }
                return self
            }
            
            request = URLRequest(url: url)
            request.timeoutInterval = api_timeout
            request.httpMethod = method
            SKRq.globalHeader.forEach { (key,value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
            header.forEach { (key,value) in
                request.setValue(value, forHTTPHeaderField: key)
            }

        }else{
            guard let url = URL(string: url) else {
                print("Error: cannot create url with urlString:\(self.url)")
                
                DispatchQueue.main.async { result(SKResult(d: nil, r: nil, e: Local_Error.invalid_url)) }
                return self
            }
            
            //先添加需要的数据到finalParaDic
            //然后添加传进来的数据到fainalParaDic
            param.forEach { (key: String, value: Any) in
                finalParaDic[key] = value
            }
            
            request = URLRequest(url: url)
            request.timeoutInterval = api_timeout
            request.httpMethod = method
            var jsonData:Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: finalParaDic, options: [])
                request.httpBody = jsonData
            } catch {
                print("Error: cannot creat Json from paraDic \(String(describing: finalParaDic))")
                
                DispatchQueue.main.async { result(SKResult(d: nil, r: nil, e: Local_Error.invalid_paramDic_to_data)) }
                return self
            }
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            SKRq.globalHeader.forEach { (key,value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
            header.forEach { (key,value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let session = URLSession(configuration: skSessionConfiguration)
        let task = session.dataTask(with: request) { (data, response, error) in
            //for log
            if (openRequestLog){
                print("url:",request.url?.absoluteString ?? "")
                print("headFields:",request.allHTTPHeaderFields ?? "")
                print("param:",finalParaDic)
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data,options:.allowFragments) as? [String: Any]
                    print("json:",json ?? "")
                    if json == nil {
                        let str = String(data: data, encoding: String.Encoding.utf8) ?? ""
                        print("string:",str)
                    }
                }
            }
            if error != nil {
                print("Error: ",error.debugDescription)
            }
            if data == nil && error == nil &&  response != nil {
                print("response:",response.debugDescription)
            }

            //return block
            DispatchQueue.main.async { result(SKResult(d: data, r: response, e: error)) }
            
            //for app level error handle
            DispatchQueue.main.async {
                if let appLevelRequestResponse = appLevelRequestResponse{
                    appLevelRequestResponse(data,response,error)
                }
            }
        }
        task.resume()
        
        
        return self
    }
}

public class SKResult {
    public var data:Data?
    public var response:URLResponse?
    public var error:Error?
    public var json:SKJSON?
    
    init(d:Data?,r:URLResponse?,e:Error?) {
        data = d
        response = r
        error = e
        json = try? SKJSON(data: data.orEmpty)
    }
}
