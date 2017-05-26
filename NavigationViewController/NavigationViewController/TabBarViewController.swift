//
//  TabBarViewController.swift
//  NavigationViewController
//
//  Created by GK on 2017/5/26.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    
}
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    //屏幕方向
    func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        return [.portrait,.portraitUpsideDown]
    }
    func tabBarControllerPreferredInterfaceOrientationForPresentation(_ tabBarController: UITabBarController) -> UIInterfaceOrientation {
        return .portrait
    }
    
}
extension TabBarViewController {
    
    override var shouldAutorotate: Bool {
        if let shouldRotate = self.selectedViewController?.shouldAutorotate {
            return shouldRotate
        }
        return super.shouldAutorotate
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let orientation = self.selectedViewController?.supportedInterfaceOrientations {
            return orientation
        }
        return super.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let orientation = self.selectedViewController?.preferredInterfaceOrientationForPresentation {
            return orientation
        }
        return super.preferredInterfaceOrientationForPresentation
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let style = self.selectedViewController?.preferredStatusBarStyle {
            return style
        }
        return super.preferredStatusBarStyle
    }
}
