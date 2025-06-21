//
//  MainSceneDIContainer.swift
//  InjectionManager
//
//  Created by JUNHYEOK LEE on 6/22/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

import NetworkInfra
import Features
import Home

public final class MainSceneDIContainer {
    
    struct Dependencies {
        
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeTabBarCoordinator(
        tabBarController: UITabBarController
    ) -> TabBarCoordinator {
        return DefaultTabBarCoordinator(
            tabBarController: tabBarController
        )
    }
}
