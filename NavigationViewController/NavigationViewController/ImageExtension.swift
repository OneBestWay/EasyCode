//
//  ImageExtension.swift
//  NavigationViewController
//
//  Created by GK on 2017/5/26.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
}

extension UIViewController {
    
    func hideBottomLineInView(_ view: UIView) {
        let navBarLineImageView = findLineImageViewUnder(view: view)
        navBarLineImageView?.isHidden = true
    }
    
    func showBottomLineInView(_ view: UIView) {
        let navBarLineImageView = findLineImageViewUnder(view: view)
        navBarLineImageView?.isHidden = false
    }
    
    func findLineImageViewUnder(view: UIView?) -> UIImageView? {
        
        guard let view = view else {
            return nil
        }
        if let imageView = view as? UIImageView, view.bounds.size.height <= 1.0 {
            return imageView
        }
        
        for subView in view.subviews {
            
            let imageView = self.findLineImageViewUnder(view: subView)
            
            if let imageView = imageView {
                return imageView
            }
        }
        return nil
    }
}
