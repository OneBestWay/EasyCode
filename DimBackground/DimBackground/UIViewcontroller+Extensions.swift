//
//  UIViewcontroller+Extensions.swift
//  DimBackground
//
//  Created by GK on 2016/11/4.
//  Copyright © 2016年 GK. All rights reserved.
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
            let dimView = UIView(frame: view.frame);
            dimView.backgroundColor = color;
            dimView.alpha = 0.0
            view.addSubview(dimView)
            
            //auto layout
            dimView.translatesAutoresizingMaskIntoConstraints = false
           
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[dimView]|", options: [], metrics: nil, views: ["dimView":dimView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimView]|", options: [], metrics: nil, views: ["dimView":dimView]))
            
            //animate alpha
            UIView.animate(withDuration: speed, animations: {
                dimView.alpha = alpha
            })
            
        case .out:
            UIView.animate(withDuration: speed, animations: {
                self.view.subviews.last?.alpha = alpha 
            }, completion: { (complete) in
                self.view.subviews.last?.removeFromSuperview()
            })
          }
    }
}
