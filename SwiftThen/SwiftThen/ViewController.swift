//
//  ViewController.swift
//  SwiftThen
//
//  Created by GK on 16/10/3.
//  Copyright © 2016年 GK. All rights reserved.


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //用户截屏触发通知
        NotificationCenter.default.addObserver(self
            , selector:#selector(ViewController.userDidTakeScreenshot(notification:)), name:NSNotification.Name.UIApplicationUserDidTakeScreenshot , object: nil);
        
    }

    func userDidTakeScreenshot(notification:NSNotification)  {
        let alertViewController = UIAlertController(title: nil, message: "已经为你产生了一张屏幕截图", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.cancel, handler: nil)
        alertViewController.addAction(cancelAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil);
    }
}

