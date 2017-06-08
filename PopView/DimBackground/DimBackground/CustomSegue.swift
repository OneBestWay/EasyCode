//
//  CustomSegue.swift
//  DimBackground
//
//  Created by GK on 2016/12/15.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue,UINavigationControllerDelegate {

    override func perform() {
        
        source.navigationController?.delegate = self
        super.perform()
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(operation: operation)
    }
    
}
