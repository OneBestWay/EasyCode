//
//  ViewController.swift
//  Router
//
//  Created by GK on 2017/2/6.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(name())

    }

}

extension UIViewController {
    func name() -> String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}
