//
//  PresentationCustomSegue.swift
//  DimBackground
//
//  Created by GK on 2016/12/15.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit

class PresentationCustomSegue: UIStoryboardSegue,UIViewControllerTransitioningDelegate {

    override func perform() {
        destination.transitioningDelegate = self
        super.perform()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimator()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
}
