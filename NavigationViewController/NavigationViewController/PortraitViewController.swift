//
//  PortraitViewController.swift
//  NavigationViewController
//
//  Created by GK on 2017/5/26.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class PortraitViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dataSource = DataSource.dataSource
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        dataSource.selectedRow = { [weak self] indexPath in
            print("\(indexPath.row)")
            
            switch indexPath.row {
            case 0:
                self?.performSegue(withIdentifier: "TranslucentBarVC", sender: nil)
            default:
                break
            }
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }

}
