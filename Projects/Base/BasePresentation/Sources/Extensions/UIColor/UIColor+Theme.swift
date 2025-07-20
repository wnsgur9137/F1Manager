//
//  UIColor+Theme.swift
//  BasePresentation
//
//  Created by JUNHYEOK LEE on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Custom Theme Colors
    
    /// 셀 배경색 - 라이트모드: systemBackground, 다크모드: secondarySystemBackground와 유사
    public static var cellBackground: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(hex: "#1C1C1E") ?? UIColor.secondarySystemBackground
            default:
                return UIColor.systemBackground
            }
        }
    }
}
