//
//  LandscapeViewController.swift
//  NavigationViewController
//
//  Created by GK on 2017/5/25.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class LandscapeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension LandscapeViewController {
    // 返回到 tableView view controller ,并传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToTableViewVC" {
            if let tableVC = segue.destination as? TableViewController {
                tableVC.receiveText = "from LandscapeViewController"
            }
        }
    }
}
