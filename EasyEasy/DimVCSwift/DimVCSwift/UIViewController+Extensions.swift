//
//  UIViewController+Extensions.swift
//  DimVCSwift
//
//  Created by GK on 2017/10/12.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

enum Direction {
    
    case `in`, out
    
}

protocol Dimmable {
    
}
extension Dimmable where Self: UIViewController {
    func dim(_ direction: Direction, color: UIColor = UIColor.black,alpha: CGFloat = 0.0, speed: Double = 0.0){
        
        switch direction {
        case .in:
            //创建并添加一个dim view
//            guard let  navigationView = self.navigationController?.view else {
//                return
//            }
            
            let dimView = UIView(frame: self.view.frame);
            dimView.backgroundColor = color;
            dimView.alpha = 0.0
            self.view.addSubview(dimView)
            
            //auto layout
            dimView.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[dimView]|", options: [], metrics: nil, views: ["dimView":dimView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimView]|", options: [], metrics: nil, views: ["dimView":dimView]))
            
            //animate alpha
            UIView.animate(withDuration: speed, animations: {
                dimView.alpha = alpha
            })
            
        case .out:
            
//            guard let  navigationView = self.navigationController?.view else {
//                return
//            }
            UIView.animate(withDuration: speed, animations: {
                self.view.subviews.last?.alpha = alpha
            }, completion: { (complete) in
                self.view.subviews.last?.removeFromSuperview()
            })
        }
    }
    
    
}

