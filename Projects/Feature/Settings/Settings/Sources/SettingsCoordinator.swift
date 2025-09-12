//
//  SettingsCoordinator.swift
//  Settings
//
//  Created by JunHyeok Lee on 9/8/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

import SettingsPresentation
import BasePresentation

public protocol SettingsCoordinatorDependencies {
    
}

public protocol SettingsCoordinator: Coordinator {
    func showSettingsViewController()
}

public final class DefaultSettingsCoordinator: SettingsCoordinator {
    
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .settings }
    
    private let dependencies: SettingsCoordinatorDependencies
    
    public init(
        navigationController: UINavigationController,
        dependencies: SettingsCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        showSettingsViewController()
    }
    
    // MARK: - SettingsView
    public func showSettingsViewController() {
        
    }
}
