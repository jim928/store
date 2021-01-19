//
//  UserProtocol.swift
//  Store
//
//  Created by mac on 19/1/2021.
//

import Foundation
import SightKit

class SKUser {
    var userName:String? = nil
    var passWord:String? = nil
    var token:String? = nil
    var rememberUserName:Bool = false
    
    func rqRegister(param:[String:Any],result:@escaping ((SKResult)->Void)) {
        
    }
}


