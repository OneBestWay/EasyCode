//
//  DimViewController.swift
//  DimBackground
//
//  Created by GK on 2016/11/4.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit

class DimViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 10;
        popUpView.layer.borderColor = UIColor.black.cgColor
        popUpView.layer.borderWidth = 0.25
        popUpView.layer.shadowColor = UIColor.black.cgColor
        popUpView.layer.shadowOpacity = 0.6
        popUpView.layer.shadowRadius = 15
        popUpView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popUpView.layer.masksToBounds = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
