//
//  BaseViewController.swift
//  NavigationViewController
//
//  Created by GK on 2017/5/25.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit
import Foundation

class BaseViewController: UIViewController {

    //仅仅支持横屏的view controllers
    let landscapeViewControllers = ["LandscapeViewController"]
    
    let hideFakeBarViewControllers = ["PortraitRootViewController","PortraitViewController","TranslucentBarViewController"]
    
    
    var customnNvigationBar: UINavigationBar {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: .default), for: .default)
        navigationBar.isTranslucent = true
        navigationBar.barStyle = UINavigationBar.appearance().barStyle
        return navigationBar
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.addSubview(customnNvigationBar)
        
       // navigationController?.navigationBar.barTintColor = UIColor.green
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.red), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(String(describing: type(of: self)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func shouldShowFakebarViewController() {
        
        let controllerName = String(describing: type(of: self))
        
        if hideFakeBarViewControllers.contains(controllerName) {
            addFakenavigationbar()
            self.navigationController?.navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: .default), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true

        }else {
            removeFakeNavigationBar()
            self.navigationController?.navigationBar.barStyle = UINavigationBar.appearance().barStyle
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: .default), for: .default)
        }
    }
    func addFakenavigationbar() {
        removeFakeNavigationBar()
        view.addSubview(customnNvigationBar)
    }
    func removeFakeNavigationBar() {
        if let _ = customnNvigationBar.superview {
            customnNvigationBar.removeFromSuperview()
        }
    }
}

extension BaseViewController {
    
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        let currentVCName = String(describing: type(of: self))
        
        if landscapeViewControllers.contains(currentVCName) {
            return [.landscape]
        }
        return [.portrait,.portraitUpsideDown]
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        
        let currentVCName = String(describing: type(of: self))
        
        if landscapeViewControllers.contains(currentVCName) {
            return .landscapeLeft
        }
        return .portrait
    }
}
