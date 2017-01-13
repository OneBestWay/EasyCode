//
//  SafeResource.swift
//  SwiftExtensions
//
//  Created by GK on 2016/12/8.
//  Copyright © 2016年 GK. All rights reserved.
//  http://swifter.tips/safe-resource/

import UIKit
import Foundation

enum ImageName: String {
    case MyImage = "my_image"
}

enum SegueName: String {
    case MySegeu = "my_segue"
}

extension UIImage {
    convenience init!(imageName: ImageName) {
        self.init(named: imageName.rawValue)
    }
}
extension UIViewController {
    func performSegueWithSegueName(segueName: SegueName, sender: Any?) {
        performSegue(withIdentifier: segueName.rawValue, sender: sender)
    }
}
