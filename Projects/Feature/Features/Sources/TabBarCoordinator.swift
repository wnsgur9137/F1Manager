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
    public var childCoordinator: [Coordinator] = []
    public var type: CoordinatorType { .tab }
    
    public let rootNavigtaionController: UINavigationController?
    public weak var navigtaionController: UINavigationController?
    public weak var tabBarController: UITabBarController?
    
    public init(
        rootNavigtaionController: UINavigationController,
        tabBarController: UITabBarController
    ) {
        self.rootNavigtaionController = rootNavigtaionController
        self.tabBarController = tabBarController
    }
    
    public func start() {
        let pages: [TabBarPage] = [
            .home
        ]
        let controllers: [UINavigationController] = pages.map { getNavigationController($0) }
        prepareTabBarController(with: controllers)
        guard let tabBarController = self.tabBarController else { return }
        rootNavigtaionController?.viewControllers = [tabBarController]
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
            break
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
