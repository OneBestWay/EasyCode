//
//  Router.swift
//  Router
//
//  Created by GK on 2017/2/8.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

struct Router {
    
}
protocol Routerable {
    //判定是否为同一个页面
    var pattern: String? { get }
    //判定是否需要变更页面内容
    var isChange: Bool? { get }
    
    func open(url: URL,sender: Dictionary<String,AnyObject>?)
}

extension Routerable {
    func open(url: URL,sender: Dictionary<String,AnyObject>?) {
        
    }
}
extension UIApplication {
    func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
