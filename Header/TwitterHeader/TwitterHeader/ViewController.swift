//
//  ViewController.swift
//  TwitterHeader
//
//  Created by GK on 2017/5/16.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class ViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var header: UIView!
    
    var headerImageView: UIImageView!
    var headerBlurImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView.image = UIImage(named: "header")
        headerImageView.contentMode = UIViewContentMode.scaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        
        header.clipsToBounds = true
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        //Pull Down
        if offset < 0 {
            let headerScaleFactor: CGFloat = -(offset) / header.bounds.height
            let headerSizeVariation = (header.bounds.height * (1.0 + headerScaleFactor) - header.bounds.size.height) / 2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizeVariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1 + headerScaleFactor, 1 + headerScaleFactor, 0)
            header.layer.transform = headerTransform
        }
        
        // Scroll Up
        else {
            //Header
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //label
            let labelTransform = CATransform3DMakeTranslation(0,max(-distance_W_LabelHeader,offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            //blur
            //headerImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)

            //Avatar
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarImage.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
                }
                
            }else {
                if avatarImage.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }
        }
        
        header.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

}

