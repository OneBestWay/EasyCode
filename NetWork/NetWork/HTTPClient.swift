//
//  HTTPClient.swift
//  NetWork
//
//  Created by GK on 2017/1/16.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T> {
    case Success(T)
    case Failure(ClientError)
}
struct HTTPClient: Client {
    
    static let `default` = HTTPClient()
    
    let host = "https://api.onevcat.com"

    private init() {
        
    }
   
    func send<T : BaseRequest>(_ res: T, completionHandler: @escaping (Result<T.Response>) -> Void) {
        
        let url = URL(string: host.appending(res.path))!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = res.method.rawValue
        urlRequest.timeoutInterval = 30
    
        let task = URLSession.shared.dataTask(with: urlRequest) {data,_,error in
            
            guard error == nil else {
                completionHandler(Result.Failure(ClientError.netError(-9000, "网络错误", "网络出现问题了")))
                return
            }
            guard let data = data else {
                completionHandler(Result.Failure(ClientError.parseError(-8000, "返回数据为空", "出错了，请稍后再试")))
                return
            }
            
            guard let objData = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completionHandler(Result.Failure(ClientError.parseError(-8001, "数据序列化出错", "出错了，请稍后再试")))
                return
            }
           
            guard let dict = objData  as? [String: Any] else {
                completionHandler(Result.Failure(ClientError.parseError(-8001, "服务端返回的数据不是一个词典", "出错了，请稍后再试")))
                return
            }
            guard let obj = T.Response.parse(dic: dict) else {
                completionHandler(Result.Failure(ClientError.parseError(-8002, "数据解析错误,服务端返回的数据不合规", "出错了，请稍候再试")))
                return
            }
           
            completionHandler(Result.Success(obj))
            
        }
        task.resume()
    }
    
}

enum ClientError: Error {
    
    case netError(Int,String,String)
    case parseError(Int,String,String)
    
    func handleError() -> String {
        
        var showDescription = "请重试一下"
        switch self {
        case .netError( _, _,let showErrorDescription):
            showDescription = showErrorDescription
        case .parseError( _, _,let showErrorDescription):
            showDescription = showErrorDescription
        }
    
        return showDescription
    }
}
