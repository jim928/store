//
//  Models.swift
//  Store
//
//  Created by mac on 19/1/2021.
//

import Foundation
import SightKit

class UserInfoModel: NSObject,SKJSONable {
    var phone : String?  // "18547844884",
    var password : String?  // "$2a$10$2YaZ\/HdRYH\/blaP8RtNtJek3RbR5tMzwNHPTPgj3DBtPYj7XP2k3u",
    var status : String?  // 1,
    var id : String?  // 13,
    var username : String?  // "Jim",
    var memberLevelId : String?  // 1,
    var createTime : String?  // "2021-01-19T10:31:19.000+00:00"

    required init?(parameter: SKJSON) {
        phone = parameter["phone"].stringValue
        password = parameter["password"].stringValue
        status = parameter["status"].stringValue
        id = parameter["id"].stringValue
        username = parameter["username"].stringValue
        memberLevelId = parameter["memberLevelId"].stringValue
        createTime = parameter["createTime"].stringValue
    }
}
