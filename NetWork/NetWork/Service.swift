//
//  Service.swift
//  NetWork
//
//  Created by GK on 2017/1/10.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit


class Service {
    
    static let sharedInstance = Service()
    
    private init() {}
    
    static private let httpUserAgent: String =  {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "Unknown"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? "Unknown"
        let productName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") ?? "Unknown"
        let productBundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") ?? "Unknown"
        let executableName = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") ?? "Unknown"
        let deviceModel = UIDevice.current.model
        let systemVersion = UIDevice.current.systemVersion
        let systemName = UIDevice.current.systemName
        let screenScale = UIScreen.main.scale
        
        let osNameVersion: String = {
            let version = ProcessInfo.processInfo.operatingSystemVersion
            let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            let osName = "iOS"
            return "\(osName) \(versionString)"
        }()
        
        var userAgent = "version=\(version),build=\(build),productName=\(productName),productBundleIdentifier=\(productBundleIdentifier),executableName=\(executableName),systemName=\(systemName),systemVersion=\(systemVersion),deviceModel=\(deviceModel),screenScale=\(screenScale)"
        
        return userAgent
    }()

    static let manager: Alamofire.SessionManager = {
       
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joined(separator: ", ")

        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "0"

        let configuration = URLSessionConfiguration.default
        
        configuration.httpCookieAcceptPolicy = .always
        configuration.httpAdditionalHeaders = ["acceptLanguage":acceptLanguage,"acceptEncoding":acceptEncoding,"User-Agent":httpUserAgent,"eppUserAgent":httpUserAgent,"eppVersion":version,"terminal":"12","terminalType":"EPP_IOS","uniqueFlag":String.UUIDString().MD5()]
        configuration.timeoutIntervalForRequest = 10
        
        let manager = Alamofire.SessionManager (
            configuration: configuration
        )
        return manager
    }()
    
}

