//
//  StoryboardIdentifiable.swift
//  StoryboardDemo
//
//  Created by GK on 2016/9/30.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit
import Foundation

extension UIStoryboard {
    enum Storyboard : String {
        case Main
        case News
    }
    
    convenience init(storyboard: Storyboard,bundle storyboardBundleOrNil: Bundle?=nil) {
        self.init(name: storyboard.rawValue, bundle: storyboardBundleOrNil)
    }
    
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable{
        let optionalViewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier)
        
        guard let viewController = optionalViewController as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier)")
        }
        
        return viewController
    }

}
protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}


extension StoryboardIdentifiable where Self: UIViewController {  //where表明该扩展只适用于UIViewCOntroller及其子类
    static  var storyboardIdentifier: String {
        return String(describing: self)
    }
}

//让每个UIViewController来遵循该协议
extension UIViewController: StoryboardIdentifiable {}


