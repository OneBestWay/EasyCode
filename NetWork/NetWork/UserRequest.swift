//
//  UserRequest.swift
//  NetWork
//
//  Created by GK on 2017/1/16.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation
import Alamofire

struct UserRequest: BaseRequest {
    
    let name: String
    
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .GET
    let parameter:[String : Any] = [:]
    
    typealias  Response = User
    
}
