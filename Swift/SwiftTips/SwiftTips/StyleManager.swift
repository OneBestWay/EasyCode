//
//  StyleManager.swift
//  SwiftTips
//
//  Created by GK on 2017/1/22.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation
import ChameleonFramework

typealias Style = StyleManager

final class StyleManager {
    
    static func setUpTheme() {
        Chameleon.setGlobalThemeUsingPrimaryColor(primaryTheme(), withSecondaryColor: theme(), usingFontName: font(), andContentStyle: content())
    }
    
    static func primaryTheme() -> UIColor {
        return FlatMint()
    }
    static func theme() -> UIColor {
        return FlatWhite()
    }
    static func toolbarTheme() -> UIColor {
        return FlatMint()
    }
    static func tintTheme() -> UIColor {
        return FlatMint()
    }
    static func titleTextTheme() -> UIColor {
        return FlatWhite()
    }
    static func titleTheme() -> UIColor {
        return FlatCoffeeDark()
    }
    static func textTheme() -> UIColor {
        return FlatMint()
    }
    static func backgroundTheme() -> UIColor {
        return FlatMint()
    }
    static func positiveTheme() -> UIColor {
        return FlatMint()
    }
    static func negativeTheme() -> UIColor {
        return FlatRed()
    }
    static func clearTheme() -> UIColor {
        return UIColor.clear
    }
    
    static func content() -> UIContentStyle {
        return UIContentStyle.contrast
    }
    
    static func font() -> String {
        return UIFont(name: FontType.Primary.name, size: FontType.Primary.size)!.fontName
    }
}
enum FontType {
    case Primary
}
extension FontType {
    var name: String {
        switch self {
        case .Primary:
            return "HelveticaNeue"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .Primary:
            return 16
        }
    }
}
