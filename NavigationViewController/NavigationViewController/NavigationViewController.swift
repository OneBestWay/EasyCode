//
//  NavigationViewController.swift
//  NavigationViewController
//
//  Created by GK on 2017/5/25.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    let landscapeViewControllers: [String] = ["LandscapeViewController"]
    let hideNavigationBarShadowImageViewController: [String] = ["PortraitExtendedViewController"]

    let screenScale = UIScreen.main.scale

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.view.backgroundColor = UIColor.white

    }
}


extension NavigationViewController: UINavigationControllerDelegate {
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return navigationController.topViewController!.supportedInterfaceOrientations
    }
    
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return (navigationController.topViewController?.preferredInterfaceOrientationForPresentation)!
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
       
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        let viewControllerString = String(describing: type(of: viewController))

        if hideNavigationBarShadowImageViewController.contains(viewControllerString) {
            // Translucency of the navigation bar is disabled so that it matches with
            // the non-translucent background of the extension view.
            navigationController.navigationBar.isTranslucent = false
            
            //The navigation bar's shadowImage is set to a transparent image
            navigationController.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
            // "Pixel" is a solid white 1x1 image.
            navigationController.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), for: .default)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //在push 时可以检查网络，是否需要授权登录等，已决定是否需要进行下一步push操作
        
        //当当前view controller不是rootViewController时，隐藏tab bottom bar
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
}

extension NavigationViewController {
    
   
    override var shouldAutorotate: Bool {
        if let shouldRotate = self.topViewController?.shouldAutorotate {
            return shouldRotate
        }
        return super.shouldAutorotate
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let orientation = self.topViewController?.supportedInterfaceOrientations {
            return orientation
        }
        return super.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let orientation = self.topViewController?.preferredInterfaceOrientationForPresentation {
            return orientation
        }
        return super.preferredInterfaceOrientationForPresentation
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let style = self.topViewController?.preferredStatusBarStyle {
            return style
        }
        return super.preferredStatusBarStyle
    }
}
