//
//  ViewController.swift
//  NetWork
//
//  Created by GK on 2017/1/10.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        HTTPClient.default.send(UserRequest(name:"onevcat")) { [weak self] result in
            switch result {
            case .Success(let user):
                DispatchQueue.main.async {
                    print("\(user.message),\(user.name)")
                }
            case .Failure(let error):
                DispatchQueue.main.async {
                   print("error message: \(error.handleError())")
                }
            }
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

