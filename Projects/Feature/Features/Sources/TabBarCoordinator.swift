//
//  TabBarCoordinator.swift
//  Features
//
//  Created by JUNHYEOK LEE on 6/22/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

import Home
import BasePresentation

public protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController? { get set }
}

public final class DefaultTabBarCoordinator: TabBarCoordinator {
    
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .tab }
    
    public let rootNavigationController: UINavigationController?
    public weak var navigationController: UINavigationController?
    public weak var tabBarController: UITabBarController?
    private let homeDIContainer: HomeDIContainer
    
    public init(
        rootNavigationController: UINavigationController,
        tabBarController: UITabBarController,
        homeDIContainer: HomeDIContainer
    ) {
        self.rootNavigationController = rootNavigationController
        self.tabBarController = tabBarController
        self.homeDIContainer = homeDIContainer
    }
    
    public func start() {
        let pages: [TabBarPage] = [
            .home
        ]
        let controllers: [UINavigationController] = pages.map { getNavigationController($0) }
        prepareTabBarController(with: controllers)
        guard let tabBarController = self.tabBarController else { return }
        rootNavigationController?.viewControllers = [tabBarController]
    }
    
    private func getNavigationController(
        _ page: TabBarPage
    ) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.tabBarItem = UITabBarItem(
            title: page.title(),
            image: page.image(),
            selectedImage: page.selectedImage()
        )
        
        switch page {
        case .home:
            let homeCoordinator = DefaultHomeCoordinator(
                navigationController: navigationController,
                dependencies: homeDIContainer
            )
            homeCoordinator.finishDelegate = self
            homeCoordinator.start()
            childCoordinators.append(homeCoordinator)
        }
        
        return navigationController
    }
    
    private func prepareTabBarController(
        with controllers: [UINavigationController]
    ) {
        tabBarController?.setViewControllers(controllers, animated: true)
        tabBarController?.selectedIndex = TabBarPage.home.orderNumber()
    }
}

extension DefaultTabBarCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter{ $0.type != childCoordinator.type }
        navigationController?.viewControllers.removeAll()
    }
}
