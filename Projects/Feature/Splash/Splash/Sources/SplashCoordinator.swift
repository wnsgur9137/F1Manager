//
//  SplashCoordinator.swift
//  Splash
//
//  Created by JunHyeok Lee on 7/21/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

import SplashPresentation
import BasePresentation

public protocol AppFlowDependencies {
    func showMainFlow()
}

public protocol SplashCoordinatorDependencies {
    func makeSplashViewController(flowAction: SplashFlowAction) -> SplashViewController
}

public protocol SplashCoordinator: Coordinator {
    func showSplashViewController()
}

public final class DefaultSplashCoordinator: SplashCoordinator {
    
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .splash }
    
    private let appFlowDependencies: AppFlowDependencies
    private let dependencies: SplashCoordinatorDependencies
    
    public init(
        appFlowDependencies: AppFlowDependencies,
        dependencies: SplashCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.appFlowDependencies = appFlowDependencies
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    public func start() {
        showSplashViewController()
    }
    
    public func showSplashViewController() {
        let flowAction = SplashFlowAction(
            showMainView: showMainView
        )
        let viewController = dependencies.makeSplashViewController(flowAction: flowAction)
        self.navigationController?.viewControllers = [viewController]
    }
    
    private func showMainView() {
        appFlowDependencies.showMainFlow()
    }
}
