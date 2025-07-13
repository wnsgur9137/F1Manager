//
//  HomeDIContainer.swift
//  Home
//
//  Created by JUNHYEOK LEE on 7/13/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import HomeData
import HomeDomain
import HomePresentation
import BasePresentation

public final class HomeDIContainer: DIContainer {
    
    public override init() {
        super.init()
    }
    
}

extension HomeDIContainer: HomeCoordinatorDependencies {
    public func makeHomeViewController() -> HomeViewController {
        let viewController = HomeViewController.create()
        return viewController
    }
}
