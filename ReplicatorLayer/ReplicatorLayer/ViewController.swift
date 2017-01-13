//
//  ViewController.swift
//  ReplicatorLayer
//
//  Created by GK on 2016/12/14.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    let subLayerWidth: CGFloat = 50.0
    let subLayerheight: CGFloat = 50.0
    let interspace: CGFloat = 8.0
    let xInstances: CGFloat = 7.0
    let yInstances: CGFloat = 5.0
    
    
    lazy var whiteLayer: CALayer = {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.position = CGPoint(x: 50, y: 50)
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()
    
    lazy var xReplicatorLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        layer.position = CGPoint(x: self.view.frame.width/2.0, y: 50)
        layer.backgroundColor = UIColor.clear.cgColor
        layer.instanceDelay = 0.8
        layer.instanceCount = 3 // 1
        layer.instanceTransform = CATransform3DMakeTranslation(100, 0, 0) // 2
        return layer
    }()
    
    lazy var yReplicatorLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 1024, height: 768)
        layer.position = CGPoint(x: 1024/2.0, y: 768/2.0)
        layer.backgroundColor = UIColor.clear.cgColor
        layer.instanceCount = 3
        layer.instanceTransform = CATransform3DMakeTranslation(0, 100, 0)
        layer.instanceDelay = 0.8
        return layer
    }()
    
    lazy var scaleAnimation: CABasicAnimation = {
        let basicAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        basicAnimation.fromValue = 1.0
        basicAnimation.toValue = 0.0
        basicAnimation.duration = 3.0
        basicAnimation.beginTime = 0.5
        basicAnimation.autoreverses = true
        return basicAnimation
    }()

    lazy var groupAnimation: CAAnimationGroup = {
        let group = CAAnimationGroup()
        group.animations = [self.cornerRadiusAnimation, self.scaleAnimation]
        group.duration = 7.0
        group.repeatCount = MAXFLOAT
        return group
    }()
    
    lazy var cornerRadiusAnimation: CABasicAnimation = {
        let basicAnimation = CABasicAnimation(keyPath: "cornerRadius")
        basicAnimation.fromValue = 0.0
        basicAnimation.toValue = 75.0
        basicAnimation.duration = 3.0
        basicAnimation.beginTime = 0.5
        basicAnimation.autoreverses = true
        return basicAnimation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.lightGray

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        whiteLayer.add(groupAnimation, forKey: "groupAnimation")
        
        xReplicatorLayer.addSublayer(whiteLayer) // 1
        yReplicatorLayer.addSublayer(xReplicatorLayer) // 2
        view.layer.addSublayer(yReplicatorLayer) // 3
    }

    func addRootlayer() {
        let centralPoint = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        let firstLayerposition = CGPoint(x: centralPoint.x - (subLayerWidth + interspace)*(xInstances - 1)/2.0, y: centralPoint.y - (subLayerheight + interspace)*(yInstances - 1)/2.0)
        
        let xlayer = CAReplicatorLayer()
        xlayer.instanceCount = Int(xInstances)
        xlayer.instanceDelay = 0.1
        xlayer.instanceGreenOffset = -0.1
        xlayer.instanceRedOffset = -0.15
        xlayer.instanceBlueOffset = -0.07
        xlayer.preservesDepth = true
        xlayer.instanceTransform = CATransform3DMakeTranslation(subLayerWidth + interspace, 0, 0)
        xlayer.add(pushAnimation(), forKey: "pushAnimation")
        
        let ylayer = CAReplicatorLayer()
        ylayer.instanceCount = Int(yInstances)
        ylayer.instanceDelay = 0.2
        ylayer.instanceGreenOffset = -0.01
        ylayer.instanceRedOffset = -0.1
        ylayer.instanceBlueOffset = -0.08
        ylayer.preservesDepth = true
        ylayer.instanceTransform = CATransform3DMakeTranslation(subLayerWidth + interspace, 0, 0)
        
        let zLayer = CAReplicatorLayer()
        zLayer.instanceCount = 3
        zLayer.instanceDelay = 0.35
        zLayer.instanceGreenOffset = -0.1
        zLayer.instanceRedOffset = -0.07
        zLayer.instanceBlueOffset = -0.1
        zLayer.preservesDepth = true
        zLayer.instanceTransform = CATransform3DMakeTranslation(0, 0, -100)
        zLayer.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        zLayer.position = CGPoint(x: self.view.bounds.size.width/2.0, y: self.view.bounds.size.height/2.0)
        
        let rootlayer = CALayer()
        rootlayer.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        rootlayer.position = CGPoint(x: self.view.bounds.size.width/2.0, y: self.view.bounds.size.height/2.0)
        rootlayer.backgroundColor = UIColor.darkGray.cgColor
        
        var tI = CATransform3DIdentity
        tI.m34 = 1.0 / -900
        rootlayer.sublayerTransform = tI
        
        let layer1 = CALayer()
        layer1.position = firstLayerposition
        layer1.bounds = CGRect(x: 0, y: 0, width: subLayerWidth, height: subLayerheight)
        layer1.backgroundColor = UIColor.yellow.cgColor
        layer1.cornerRadius = 10
        layer1.shadowColor = UIColor.black.cgColor
        layer1.shadowRadius = 4.0
        layer1.shadowOffset = CGSize(width: 0, height: 3)
        layer1.shadowOpacity = 0.8
        layer1.opacity = 0.8
        layer1.borderColor = UIColor.white.cgColor
        layer1.borderWidth = 2.0
        
        zLayer.add(rotationAnimation(), forKey: "rotationAnimation")
        
        xlayer.addSublayer(layer1)
        ylayer.addSublayer(xlayer)
        rootlayer.addSublayer(zLayer)
        self.view.layer.addSublayer(rootlayer)
        
        layer1.add(waveAnimation(), forKey: "waveAnimation")
    }
    func pushAnimation() -> CABasicAnimation {
        let pushAnim = CABasicAnimation(keyPath: "instanceTransform")

        pushAnim.fromValue = NSValue(caTransform3D: CATransform3DMakeTranslation(subLayerWidth + interspace, 0, 0))
        pushAnim.toValue = NSValue(caTransform3D: CATransform3DMakeTranslation(subLayerWidth + interspace + 60.0, 0, 0))
        pushAnim.duration = 3.0
        pushAnim.autoreverses = true
        pushAnim.repeatCount = HUGE
        pushAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return pushAnim
    }
    
    func rotationAnimation() -> CABasicAnimation {
        
       let rotAnim = CABasicAnimation(keyPath: "transform")
        
       let t = CATransform3DIdentity
        
       rotAnim.fromValue = NSValue(caTransform3D: CATransform3DRotate(t, -0.8, 1, 0, 0))
       rotAnim.toValue = NSValue(caTransform3D: CATransform3DRotate(t, 0.9, 1, 0, 0))
       rotAnim.duration = 5.0
       rotAnim.autoreverses = true
       rotAnim.repeatCount = HUGE
       rotAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
   
       return rotAnim
    }
    
    func waveAnimation() -> CABasicAnimation {
        
        let waveAnim = CABasicAnimation(keyPath: "transform")
        waveAnim.fromValue = NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 100))
        waveAnim.toValue = NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, -100))
        waveAnim.duration = 1.5
        waveAnim.autoreverses = true
        waveAnim.repeatCount = HUGE
        waveAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return waveAnim
    }
}

