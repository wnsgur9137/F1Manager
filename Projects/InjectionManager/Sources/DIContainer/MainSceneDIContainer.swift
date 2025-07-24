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
import Splash

public final class MainSceneDIContainer {
    
    private let rootNavigationController: UINavigationController
    private let tabBarController: UITabBarController
    
    struct Dependencies {
        let networkManager: NetworkManager
    }
    
    private let dependencies: Dependencies
    
    init(
        rootNavigationController: UINavigationController,
        tabBarController: UITabBarController,
        dependencies: Dependencies
    ) {
        self.rootNavigationController = rootNavigationController
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    private func makeHomeDIContainer() -> HomeDIContainer {
        let dependencies = HomeDIContainer.Dependencies(
            networkManager: dependencies.networkManager
        )
        return HomeDIContainer(dependencies: dependencies)
    }
    
    public func makeTabBarCoordinator() -> TabBarCoordinator {
        return DefaultTabBarCoordinator(
            rootNavigationController: rootNavigationController,
            tabBarController: tabBarController,
            homeDIContainer: makeHomeDIContainer()
        )
    }
    
    private func makeSplashDIContainer() -> SplashDIContainer {
        let dependencies = SplashDIContainer.Dependencies(
            networkManager: dependencies.networkManager
        )
        return SplashDIContainer(dependencies: dependencies)
    }
    
    public func makeSplashCoordinator() -> SplashCoordinator {
        return DefaultSplashCoordinator(
            appFlowDependencies: self,
            dependencies: makeSplashDIContainer(),
            navigationController: rootNavigationController
        )
    }
}

extension MainSceneDIContainer: AppFlowDependencies {
    public func showMainFlow() {
        let tabBarCoordinator = makeTabBarCoordinator()
        tabBarCoordinator.start()
    }
}
