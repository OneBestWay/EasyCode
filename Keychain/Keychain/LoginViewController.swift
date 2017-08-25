//
//  LoginViewController.swift
//  Keychain
//
//  Created by GK on 2017/7/31.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController  {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    let usernameKey = "batman"
    let passwordKey = "Hello Bruce"
    
    
    func checkLogin(username: String,password: String) -> Bool {
        return username == usernameKey && password == passwordKey
    }
    
    
    @IBAction func loginOrCreateButtonClicked(_ sender: UIButton) {
        
    }
}
