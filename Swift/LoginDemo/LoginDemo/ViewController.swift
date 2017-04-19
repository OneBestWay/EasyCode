//
//  ViewController.swift
//  LoginDemo
//
//  Created by GK on 2017/2/24.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit
import LocalAuthentication

enum LAError : Int {
    case AuthenticationFailed   //用户没有提供正确的授权，如用了错误的手指
    case UserCancel             //用户特意取消了授权
    case UserFallBack           //用户特意不用TouchID
    case SystemCancel           //系统停止了授权，可能因为另外一个应用打开了
    case PasscodeNotSet         //在用户的setting 里面用户没有设置密码
    case TouchIDNotAvailable    //设备不支持TouchID
    case TouchIDNotEnrolled     //设备支持，单用户没设置
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func authenticateUser() {
        
        let context = LAContext()
        
        var error: NSError?
        
        let reasonString = "用户做什么的时候需要授权"
        
        //判断设备是否支持TouchID 授权，如果为true TouchID授权已经在设备的setting里面使能，至少已经设定了一个手指
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context .evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) in
                
                if success {
                    
                }
                else{
                    print(evalPolicyError?.localizedDescription ?? "Touch ID授权失败")
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user")
                        
                    case LAError.UserFallBack.rawValue:
                        print("User selected to enter custom password")
                        
                        NSOperationQueue.
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                        
                    default:
                        println("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }
                
            } as! (Bool, Error?) -> Void)]
        
        } else {
            
        }
    }
}

