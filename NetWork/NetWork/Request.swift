//
//  Request.swift
//  NetWork
//
//  Created by GK on 2017/1/16.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
}

protocol BaseRequest {
    
    associatedtype Response: Decodable
    
    var path: String {  get }
    
    var method: HTTPMethod { get }
    var parameter: [String: Any] {  get }
    
}
