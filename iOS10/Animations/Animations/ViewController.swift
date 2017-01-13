//
//  ViewController.swift
//  Animations
//
//  Created by GK on 2016/12/15.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var lastTapRect = CGRect(x: 20, y: 20, width: 60, height: 60)
    
    lazy var redView: UIView = {
        let redView = UIView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
        redView.backgroundColor = UIColor.red
        redView.layer.cornerRadius = 30
        return redView
    }()
    
    
    lazy var animator: UIViewPropertyAnimator = {
        let cubicParameters = UICubicTimingParameters(controlPoint1: CGPoint(x: 0, y: 0.5), controlPoint2: CGPoint(x: 1, y: 0.5))
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: cubicParameters)
        animator.isInterruptible = true
        return animator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(redView)
     
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handTap(from:)))
        view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handPan(from:)))
        redView.addGestureRecognizer(pan)
    }
    func handPan(from recognizer: UIPanGestureRecognizer) {
        
        let touchPoint = recognizer.location(in: view)
        
        switch recognizer.state {
        case .began:
            if animator.isRunning {
                animator.stopAnimation(true)
            }
        case .changed:
            redView.center = touchPoint
            redView.backgroundColor = UIColor.green
        case .ended,.cancelled:
            redView.backgroundColor = UIColor.red
            animator.addAnimations {
                self.redView.frame = self.lastTapRect
                //self.redView.frame = CGRect(x: 20, y: 20, width: 60, height: 60)
            }
            animator.startAnimation()
            
        default:
            break
        }
    }
    func handTap(from recognizer: UITapGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        
        switch recognizer.state {
        case .recognized:
            if animator.isRunning {
                animator.stopAnimation(true)  //true inactive state , false: stopped state
            }
            animator.addAnimations {
                self.redView.frame = CGRect(x: touchPoint.x - 30, y: touchPoint.y - 30, width: 60, height: 60)
                self.lastTapRect = self.redView.frame;

            }
            animator.startAnimation()
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

