//
//  Font+F1.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/14/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

extension UIFont {
    
    private enum FontName: String {
        case f1Bold = "Formula1-Bold"
        case f1Regular = "Formula1-Regular"
        case f1Wide = "Formula1-Wide"
    }
    
    public enum F1FontWeight {
        case bold
        case regular
        case wide
    }
    
    public enum FontWeight {
        case regular
        case medium
        case semiBold
        case bold
    }
    
    private static func f1Bold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: FontName.f1Regular.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    private static func f1Regular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: FontName.f1Regular.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    private static func f1Wide(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: FontName.f1Wide.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    public static func f1(
        _ weight: F1FontWeight,
        size: CGFloat
    ) -> UIFont {
        switch weight {
        case .bold: return f1Bold(size: size)
        case .regular: return f1Regular(size: size)
        case .wide: return f1Wide(size: size)
        }
    }
    
}
