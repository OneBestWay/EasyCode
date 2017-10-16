//
//  ViewController.swift
//  DimVCSwift
//
//  Created by GK on 2017/10/12.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class ViewController: UIViewController,Dimmable {

    let dimLevel:CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dim(.in,  alpha: dimLevel, speed: dimSpeed)
    }
    @IBAction func unwindFromSecondary(_ segue:UIStoryboardSegue) {
        dim(.out,  speed: dimSpeed)
    }
}

