//
//  ViewController.swift
//  C4iOS
//
//  Created by GK on 2017/2/7.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit
import Foundation

class InfiniteScrollViewController: UIViewController {

    let infiniteScrollView = InfiniteScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        infiniteScrollView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 300);
        self.view.addSubview(infiniteScrollView)
        addVisualIndicators()
    }

    func addVisualIndicators() {
        let count = 20
        
        let gap = 50.0
        
        let dx = 40.0
        
        let width = Double(count + 1) * gap
        
        for x in 0 ... count {
            let point = CGPoint(x: Double(x) * gap + dx, y: 150 + 20)
            createIndicator(text: "\(x)", at: point)
        }
        
        var x: Int = 0
        var offset = dx
        
        while offset < Double(infiniteScrollView.frame.size.width) {
            
            let point = CGPoint(x: width + offset, y: 150 + 20)
            createIndicator(text: "\(x)", at: point)
            offset += gap
            
            x += 1
        }
        infiniteScrollView.contentSize = CGSize(width: CGFloat(width) + infiniteScrollView.frame.size.width, height: 0)
    }
    
    func createIndicator(text: String, at point: CGPoint) {
        let ts = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        ts.text = text
        ts.center = point
        
        infiniteScrollView.addSubview(ts)
    }
   

}

