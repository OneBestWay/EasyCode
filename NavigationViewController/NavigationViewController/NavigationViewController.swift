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
        self.interactivePopGestureRecognizer?.delegate = self
        
        self.view.backgroundColor = UIColor.white
        
        //navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationBar.shadowImage = UIImage()
        //navigationBar.isTranslucent = true
        
        //navigationBar.tintColor = UIColor.red
        //navigationBar.backgroundColor = UIColor.red
    }
}

extension NavigationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if viewControllers.count <= 1{
            return false
        } else {
            return true
        }
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
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
 
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //在push 时可以检查网络，是否需要授权登录等，已决定是否需要进行下一步push操作
        
        //当当前view controller不是rootViewController时，隐藏tab bottom bar
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
       // let previousVC = self.viewControllers[self.viewControllers.count - 2]
        
       // if let currentVC = self.viewControllers.last {
       //     if !currentVC.useTransparentNavigationBar && !previousVC.useTransparentNavigationBar {
       //         shouldAddFakeNavigationBar = false
       //     }else {
       //         shouldAddFakeNavigationBar = true
      //      }
       // }else {
        //    shouldAddFakeNavigationBar = true
       // }
        return super.popViewController(animated: animated)
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

extension NavigationViewController {
    func transparentNavigationbar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        
        self.navigationBar.tintColor = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 1.0)
    }
    
    //self.navigationController?.navigationBar.barStyle = UINavigationBar.appearance().barStyle
    //self.navigationController?.navigationBar.isTranslucent = true
    //self.navigationController?.navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: .default), for: .default)
}
