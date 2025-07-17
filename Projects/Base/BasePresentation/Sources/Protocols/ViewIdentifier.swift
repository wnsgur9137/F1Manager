//
//  ViewIdentifier.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

protocol ViewIdentifier: AnyObject {
    static var identifier: String { get }
}
