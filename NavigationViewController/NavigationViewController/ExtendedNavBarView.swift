//
//  ExtendedNavBarView.swift
//  NavigationViewController
//
//  Created by GK on 2017/5/26.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class ExtendedNavBarView: UIView {

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        //use the layer shadow to draw a one pixel hairline under the view
        layer.shadowOffset = CGSize(width: 0, height: CGFloat(1) / UIScreen.main.scale)
        layer.shadowRadius = 0
        
        // UINavigationBar's hairline is adaptive, its properties change with
        // the contents it overlies.  You may need to experiment with these
        // values to best match your content.
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
    }

}
