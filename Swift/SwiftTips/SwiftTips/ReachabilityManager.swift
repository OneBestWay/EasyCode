//
//  ReachabilityManager.swift
//  SwiftTips
//
//  Created by GK on 2017/1/20.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation
import ReachabilitySwift

enum NetworkStatus: CustomStringConvertible {
    
    case notReachable, reachableViaWiFi, reachableViaWWAN
    
    var description: String {
        switch self {
        case .reachableViaWWAN: return "Cellular"
        case .reachableViaWiFi: return "WiFi"
        case .notReachable: return "No Connection"
        }
    }
}
protocol NetworkStatusListener : class {
    func networkStatusDidChange(status: NetworkStatus)
}
class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    var listeners = [NetworkStatusListener]()
    
    fileprivate var notifierRunning = false
    
    private override init() {
        super.init()
    }
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    
    var isNetworkAvailable: Bool {
        return reachabilityStatus != .notReachable
    }
    
    let reachability = Reachability()!
    
    func startMonitoring() {
        
        if notifierRunning {
            return
        }
        notifierRunning = true
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    func stopMonitoring() {
        
        if !notifierRunning {
            return
        }
        notifierRunning = false

        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    func addListener(listener: NetworkStatusListener) {
        listeners.append(listener)
    }
    func removeListener(listener: NetworkStatusListener) {
        listeners = listeners.filter { $0 !== listener }
    }
    
    func reachabilityChanged(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            debugPrint("Network become unreachable")
        case .reachableViaWiFi:
            debugPrint("Network reachable through WiFi")
        case .reachableViaWWAN:
            debugPrint("Network reachable through Cellular Data")
        }
        
//        for listener in listeners {
//            listener.networkStatusDidChange(status: transferToNetworkStatus(status: reachability.currentReachabilityStatus))
//        }
    }
    
    func transferToNetworkStatus(status: Reachability.NetworkStatus) -> NetworkStatus {
        
        var netStatus: NetworkStatus = .notReachable
        
        switch status {
        case .notReachable:
            netStatus = .notReachable
        case .reachableViaWWAN:
            netStatus = .reachableViaWWAN
        case .reachableViaWiFi:
            netStatus = .reachableViaWiFi
        }
        
        return netStatus
    }
}
