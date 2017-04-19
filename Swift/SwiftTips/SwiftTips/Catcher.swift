//
//  Catch.swift
//  SwiftTips
//
//  Created by GK on 2017/1/22.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation

public protocol Cachable {
    
    var fileName: String { get }
    func transform() -> Data
    
}

final public class Cacher {
    let destination: URL
    private let queue = OperationQueue()
    
    public enum CacheDestination {
        case temporary
        case atFolder(String)
    }
    
    init(destination: CacheDestination) {
        switch destination {
        case .temporary:
            self.destination = URL(fileURLWithPath: NSTemporaryDirectory())
        case .atFolder(let folder):
            let documentFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            self.destination = URL(fileURLWithPath: documentFolder).appendingPathComponent(folder, isDirectory: true)
        }
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(at: self.destination, withIntermediateDirectories: true, attributes:nil)
        } catch {
            fatalError("Unable to create catch URL \(error)")
        }
    }
    
    func persist(item: Cachable, completion: @escaping(_ url: URL) -> Void) {
        let url = destination.appendingPathComponent(item.fileName, isDirectory: false)
        
        let operation = BlockOperation {
            do {
                try item.transform().write(to: url, options: [.atomicWrite])
            } catch {
                fatalError("Failed to write item to cache: \(error)")
            }
        }
        
        operation.completionBlock = {
            completion(url)
        }
        queue.addOperation(operation)
    }
    func readDataURL(catchURl: String) -> Data? {
        
        guard let url = URL(string: catchURl) else {
            return nil
        }
        
        var data: Data
        
        do {
            data = try Data(contentsOf: url)
        } catch {
            return nil
            //fatalError("Failed to write item to cache: \(error)")
        }
        return data
    }
    func readArrayURL(catchURL: String) -> Array<Any>? {
        return NSArray(contentsOfFile: catchURL) as? Array<Any>
    }
    func readDictionaryURL(catchURL: String) -> Dictionary<String, Any>? {
    
        guard let data = readDataURL(catchURl: catchURL) else  {
            return nil
        }
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data)
            if let jsonArray = jsonResult as? [String: Any] {
                return jsonArray
            }else {
                return nil
            }
        } catch {
            print("JSON Processing Failed \(error)")
            return nil
        }
    }
}
