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
    case settings
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .settings
        default: return nil
        }
    }
    
    /// TabBar title
    /// - Returns: Title
    func title() -> String {
        switch self {
        case .home: return "홈"
        case .settings: return "설정"
        }
    }
    
    /// order number(Index)
    /// - Returns: Index
    func orderNumber() -> Int {
        switch self {
        case .home: return 0
        case .settings: return 1
        }
    }
    
    /// TabBar image
    /// - Returns: image
    func image() -> UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house")
        case .settings: return UIImage(systemName: "gearshape")
        }
    }
    
    /// TabBar selected image
    /// - Returns: selected image
    func selectedImage() -> UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house.fill")
        case .settings: return UIImage(systemName: "gearshape.fill")
        }
    }
}
