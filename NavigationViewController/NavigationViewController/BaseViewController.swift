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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
