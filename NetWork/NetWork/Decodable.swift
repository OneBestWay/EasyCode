//
//  Decodable.swift
//  NetWork
//
//  Created by GK on 2017/1/16.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation

protocol Decodable {
    static func parse(dic: Dictionary<String, Any>) -> Self?
}
