//
//  ViewController.swift
//  SwiftTips
//
//  Created by GK on 2017/1/20.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shadowColor = Color.shadow.value
        
        self.view.backgroundColor = Style.negativeTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ReachabilityManager.shared.addListener(listener: self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ReachabilityManager.shared.removeListener(listener: self)
    }
}

extension ViewController: NetworkStatusListener {
    func networkStatusDidChange(status: NetworkStatus) {
        switch status {
        case .notReachable:
            debugPrint("ViewController: Network became unreachable")
        case .reachableViaWiFi:
            debugPrint("ViewController: Network reachable through WiFi")
        case .reachableViaWWAN:
            debugPrint("ViewController: Network reachable through Cellular Data")
        }
    }
}
