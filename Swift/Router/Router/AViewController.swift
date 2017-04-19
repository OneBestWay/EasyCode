//
//  AViewController.swift
//  Router
//
//  Created by GK on 2017/2/8.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation
import UIKit

class AViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(name())
    }
    
}
extension AViewController: Routerable {
    var pattern: String? = "AVC"
    var isChange: Bool? = {
        return true
    }()
    func open(url: URL, sender: Dictionary<String, AnyObject>?) {
        
    }
}


