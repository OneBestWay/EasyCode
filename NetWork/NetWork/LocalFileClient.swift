//
//  LocalFileClient.swift
//  NetWork
//
//  Created by GK on 2017/1/16.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation

enum TestFileName: String {
    case user = "testUser"
}


struct LocalFileClient: Client {
    
    static let `default` = LocalFileClient()
    private init() {
        
    }
    let host = "https://api.onevcat.com"
    
    func send<T : BaseRequest>(_ res: T, completionHandler: @escaping (Result<T.Response>) -> Void) {
        switch res.path {
        case "/users/onevcat":
            guard let fileURl = Bundle(for: NetWorkTests.self).url(forResource: TestFileName.user.rawValue, withExtension: "")  else {
                fatalError()
            }
            
            guard let data = try? Data(contentsOf: fileURl) else {
                fatalError()
            }
            
            guard let objData = try? JSONSerialization.jsonObject(with: data, options: []) else {
                fatalError()
            }
            guard let dict = objData  as? [String: Any] else {
                 fatalError()
            }
            guard let obj = T.Response.parse(dic: dict) else {
                fatalError()
            }
            completionHandler(Result.Success(obj))
        default:
            fatalError("Unknown path")
        }
    }
    
}
