//
//  AppFlowCoordinator.swift
//  F1Manager
//
//  Created by JUNHYEOK LEE on 7/1/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

import InjectionManager
import Features

final class AppFlowCoordinator {
    
    private let rootNavigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        rootNavigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.rootNavigationController = rootNavigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer(rootNavigationController: rootNavigationController)
        let flow = mainSceneDIContainer.makeSplashCoordinator()
//        let flow = mainSceneDIContainer.makeTabBarCoordinator()
        flow.start()
    }
}
