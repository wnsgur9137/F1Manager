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
    
    private let rootNavigtaionController: UINavigationController
    private let tabBarController: UITabBarController
    
    struct Dependencies {
        
    }
    
    private let dependencies: Dependencies
    
    init(
        rootNavigationController: UINavigationController,
        tabBarController: UITabBarController,
        dependencies: Dependencies
    ) {
        self.rootNavigtaionController = rootNavigationController
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    private func makeHomeDIContainer() -> HomeDIContainer {
        return HomeDIContainer()
    }
    
    public func makeTabBarCoordinator() -> TabBarCoordinator {
        return DefaultTabBarCoordinator(
            rootNavigtaionController: rootNavigtaionController,
            tabBarController: tabBarController,
            homeDIContainer: makeHomeDIContainer()
        )
    }
}
