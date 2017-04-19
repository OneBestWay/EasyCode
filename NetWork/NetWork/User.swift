//
//  User.swift
//  NetWork
//
//  Created by GK on 2017/1/16.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation

struct User: CustomStringConvertible{
    
    let name: String
    let message: String
    
    init?(obj: Dictionary<String, Any>) {
        
        guard let name = obj["name"] as? String else {
            return nil
        }
        
        guard let message = obj["message"] as? String else {
            return nil
        }
        
        self.name = name
        self.message = message
    }
    
    var description: String {
        return "User: { name: \(name), message: \(message) }"
    }
}

extension User: Decodable {
    static func parse(dic: Dictionary<String,Any>) -> User? {
        return User(obj: dic)
    }
}
