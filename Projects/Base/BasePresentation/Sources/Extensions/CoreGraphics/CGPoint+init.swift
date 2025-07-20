//
//  CGPoint+init.swift
//  BasePresentation
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import CoreGraphics

public extension CGPoint {
    init(x: Double, y: Double) {
        self.init(x: CGFloat(x), y: CGFloat(y))
    }
}
