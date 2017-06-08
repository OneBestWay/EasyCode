//
//  Animator.swift
//  DimBackground
//
//  Created by GK on 2016/12/15.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit

class Animator: NSObject,UIViewControllerAnimatedTransitioning {

    private var operation: UINavigationControllerOperation
    
    let damping: CGFloat = 0.5
    let velocity: CGFloat = 10.0
    
    init(operation: UINavigationControllerOperation) {
        
        self.operation = operation
        
        super.init()
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        let containerView = transitionContext.containerView
        
        let halfDuration = transitionDuration(using: transitionContext)/2.0
        
        switch operation {
        case .push:
            toView.frame = CGRect(x: toView.frame.size.width, y: toView.frame.origin.y, width: toView.frame.size.width, height: toView.frame.size.height)
            containerView.addSubview(toView)
            
            UIView .animate(withDuration: halfDuration,
                            delay: 0,
                            usingSpringWithDamping: damping,
                            initialSpringVelocity: velocity,
                            options: UIViewAnimationOptions.curveLinear,
                            animations: {
                                fromView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { (finished: Bool) in
                if (finished) {
                    
                    UIView.animate(withDuration: halfDuration,
                                   delay: 0,
                                   usingSpringWithDamping: self.damping,
                                   initialSpringVelocity: self.velocity,
                                   options: UIViewAnimationOptions.curveLinear,
                                   animations: {
                                     toView.frame = CGRect(x: 0, y: 0, width: toView.frame.size.width, height: toView.frame.size.height)
                    }, completion: { (finished: Bool) in
                        if finished {
                            transitionContext.completeTransition(finished)
                        }
                    })

                }
            })
        case .pop:
            containerView.insertSubview(toView, belowSubview: fromView)
            toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
            UIView .animate(withDuration: halfDuration,
                            delay: 0,
                            usingSpringWithDamping: damping,
                            initialSpringVelocity: velocity,
                            options: UIViewAnimationOptions.curveLinear,
                            animations: {
                                fromView.frame = CGRect(x: fromView.frame.size.width, y: fromView.frame.origin.y, width: fromView.frame.size.width, height: fromView.frame.size.height)
            }, completion: { (finished: Bool) in
                if (finished) {
                    
                    UIView.animate(withDuration: halfDuration,
                                   delay: 0,
                                   usingSpringWithDamping: self.damping,
                                   initialSpringVelocity: self.velocity,
                                   options: UIViewAnimationOptions.curveLinear,
                                   animations: {
                                   toView.transform = CGAffineTransform.identity
                    }, completion: { (finished: Bool) in
                        if finished {
                            transitionContext.completeTransition(finished)
                        }
                    })
                    
                }
            })
        default:
            
            break
        }
    }
    
}
