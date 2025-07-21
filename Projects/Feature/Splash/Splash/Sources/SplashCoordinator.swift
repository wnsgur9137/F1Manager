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
    
    private let dependencies: SplashCoordinatorDependencies
    
    public init(dependencies: SplashCoordinatorDependencies) {
        self.navigationController = UINavigationController()
        self.dependencies = dependencies
    }
    
    public func start() {
        showSplashViewController()
    }
    
    public func showSplashViewController() {
        let flowAction = SplashFlowAction()
        let viewController = dependencies.makeSplashViewController(flowAction: flowAction)
        self.navigationController?.viewControllers = [viewController]
    }
}
