//
//  TableTableViewController.swift
//  NavigationViewController
//
//  Created by GK on 2017/5/25.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var receiveText: String = "" {
        
        didSet {
            self.title = receiveText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait,.portraitUpsideDown]
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
}


extension TableViewController {
    
   @IBAction func landscapeVCBack(_ segue: UIStoryboardSegue) {
        
   }
}
