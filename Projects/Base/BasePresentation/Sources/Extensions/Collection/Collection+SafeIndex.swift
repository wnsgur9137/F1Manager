//
//  Collection+SafeIndex.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 8/18/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
