//
//  TabBarPage.swift
//  Features
//
//  Created by JUNHYEOK LEE on 6/22/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

enum TabBarPage {
    case home
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        default: return nil
        }
    }
    
    /// TabBar title
    /// - Returns: Title
    func title() -> String {
        switch self {
        case .home: return "홈"
        }
    }
    
    /// order number(Index)
    /// - Returns: Index
    func orderNumber() -> Int {
        switch self {
        case .home: return 0
        }
    }
    
    /// TabBar image
    /// - Returns: image
    func image() -> UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house")
        }
    }
    
    /// TabBar selected image
    /// - Returns: selected image
    func selectedImage() -> UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house.fill")
        }
    }
}
