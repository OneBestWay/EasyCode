//
//  DismissAnimator.swift
//  DimBackground
//
//  Created by GK on 2016/12/15.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject,UIViewControllerAnimatedTransitioning {

    let damping: CGFloat = 0.5
    
    let velocity: CGFloat = 10.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)  else { return }
        
        let containerView = transitionContext.containerView
        
        let halfDuration = transitionDuration(using: transitionContext) / 2.0
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: halfDuration,
                       
                                   delay: 0.0,
                                   
                                   usingSpringWithDamping: damping,
                                   
                                   initialSpringVelocity: velocity,
                                   
                                   options: UIViewAnimationOptions.curveLinear,
                                   
                                   animations: { () -> Void in
                                    
                                    fromView.frame = CGRect(x: fromView.frame.width, y: fromView.frame.origin.y, width: fromView.frame.width, height: fromView.frame.height);
                                    
        },
                                   
                                   completion: { (finished: Bool) -> Void in
                                    
                                    if finished {
                                        
                                        UIView.animate(withDuration: halfDuration,
                                                                   
                                                                   delay: 0.0,
                                                                   
                                                                   usingSpringWithDamping: self.damping,
                                                                   
                                                                   initialSpringVelocity: self.velocity,
                                                                   
                                                                   options: UIViewAnimationOptions.curveLinear,
                                                                   
                                                                   animations: { () -> Void in
                                                                    
                                                                    toView.transform = CGAffineTransform.identity
                                                                    
                                        }, completion: { (finished: Bool) -> Void in
                                            
                                            if finished {
                                                
                                                transitionContext.completeTransition(finished)
                                                
                                            }
                                        })
                                    }
        })
    }
}
