//
//  UIView+Identifier.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

extension UIView: ViewIdentifier {
    public static var identifier: String {
        return String(describing: self)
    }
}
