//
//  InfiniteScrollView.swift
//  C4iOS
//
//  Created by GK on 2017/2/7.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class InfiniteScrollView: UIScrollView {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var current = contentOffset
        
        if current.x < 0 {
            current.x = contentSize.width - frame.width
            contentOffset = current
        } else if current.x >= contentSize.width - frame.width {
            current.x = 0
            contentOffset = current
        }
    }
}
