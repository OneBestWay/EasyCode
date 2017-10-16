//
//  DimViewController.swift
//  DimVCSwift
//
//  Created by GK on 2017/10/12.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class DimViewController: UIViewController {

    @IBOutlet weak var popView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        modalPresentationStyle = .overFullScreen
        
        popView.layer.cornerRadius = 10;
        popView.layer.borderColor = UIColor.black.cgColor
        popView.layer.borderWidth = 0.25
        popView.layer.shadowColor = UIColor.black.cgColor
        popView.layer.shadowOpacity = 0.6
        popView.layer.shadowRadius = 15
        popView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popView.layer.masksToBounds = false;
    }

    @IBAction func closeClicked(_ sender: UIButton) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
