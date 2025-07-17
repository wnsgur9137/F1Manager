//
//  Font+F1.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/14/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

extension UIFont {
    
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
        BasePresentationFontFamily.registerAllCustomFonts()
        return BasePresentationFontFamily.Formula1.displayBold.font(size: size)
    }
    
    private static func f1Regular(size: CGFloat) -> UIFont {
        BasePresentationFontFamily.registerAllCustomFonts()
        return BasePresentationFontFamily.Formula1.displayRegular.font(size: size)
    }
    
    private static func f1Wide(size: CGFloat) -> UIFont {
        BasePresentationFontFamily.registerAllCustomFonts()
        return BasePresentationFontFamily.Formula1.displayWide.font(size: size)
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
