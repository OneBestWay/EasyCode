//
//  AlertViewController.swift
//  DimBackground
//
//  Created by GK on 2017/6/7.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation
import UIKit

public class AlertViewController: UIViewController {
    
    //globale options
    static var globalOptions = PopUpOptions()
    //Local options
    var options: PopUpOptions!
   
    
    //pop view controller 
    var viewController: UIViewController!
    
    var keyboardIsVisible = false
    
    convenience init(alertViewController: UIViewController,popUpOptions: PopUpOptions? = nil) {
        
        self.init()

        self.viewController = alertViewController
        initOptions(popUpOptions)
        
    }
    
    
    func initPopUp() {
        let contentView = viewController.view.subviews.first!.bounds
        viewController.view.bounds = contentView
        
        guard !contentView.isEmpty else {
            fatalError("AAll child views must be encapsulate in a single UIView instace. Aborting ...")
        }
        
        if #available(iOS 9.0 , *) {
            self.loadViewIfNeeded()
        }
        
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = view.bounds.size
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(scrollView)
        scrollView.bindWithBounds()
        
        let scrollContentView = UIView(frame: scrollView.bounds)
        scrollView.addSubview(scrollView)
        
        addChildViewController(viewController)
        scrollContentView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        modalPresentationStyle = .overFullScreen
        viewController.view.layer.cornerRadius = options.cornerRadius
        viewController.view.layer.masksToBounds = true

    }
    func initOptions(_ options: PopUpOptions?) {
        if let option = options {
            self.options = option
        }else {
            self.options = AlertViewController.globalOptions
        }
    }
    
    func togglePopup(_ show: Bool = false) {
        
    }
}

public struct PopUpOptions {
    var storyboardName: String?
    var dismissTag: Int?
    var cornerRadius: CGFloat = 4.5
    var animationDuration = 2.0
    var backgroundColor = UIColor.black.withAlphaComponent(0.7)
}
extension UIView {
    /// Bind view with super view
    func bindWithBounds() {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }

}
