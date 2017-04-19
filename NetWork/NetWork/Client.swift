//
//  Client.swift
//  NetWork
//
//  Created by GK on 2017/1/16.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation

protocol Client  {
    func send<T : BaseRequest>(_ res: T, completionHandler: @escaping (Result<T.Response>) -> Void)
    var host: String { get }
}
