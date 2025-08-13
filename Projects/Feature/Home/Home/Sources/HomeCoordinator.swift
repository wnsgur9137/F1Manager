//
//  HomeCoordinator.swift
//  Home
//
//  Created by JUNHYEOK LEE on 7/13/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

import HomePresentation
import BasePresentation

public protocol HomeCoordinatorDependencies {
    func makeHomeViewController(flowAction: HomeFlowAction) -> HomeViewController
    func makeDriverListViewController(flowAction: DriverListFlowAction) -> DriverListViewController
    func makeDriverDetailViewController(driver: DriverModel, flowAction: DriverDetailFlowAction) -> DriverDetailViewController
    func makeRaceListViewController(flowAction: RaceListFlowAction) -> RaceListViewController
    func makeRaceDetailViewController(race: RaceModel, flowAction: RaceDetailFlowAction) -> RaceDetailViewController
}

public protocol HomeCoordinator: Coordinator {
    func showHomeViewController()
}

public final class DefaultHomeCoordinator: HomeCoordinator {
    
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .home }
    
    private let dependencies: HomeCoordinatorDependencies
    
    public init(
        navigationController: UINavigationController,
        dependencies: HomeCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        showHomeViewController()
    }
    
    public func showHomeViewController() {
        let flowAction = HomeFlowAction(
            navigateToDriverList: showDriverListViewController,
            driverSelected: showDriverDetailViewController,
            navigateToRaceList: showRaceListViewController,
            raceSelected: showRaceDetailViewController
        )
        let viewController = dependencies.makeHomeViewController(flowAction: flowAction)
        self.navigationController?.viewControllers = [viewController]
    }
    
    private func showDriverListViewController() {
        let flowAction = DriverListFlowAction(
            backButtonTapped: popViewController,
            driverSelected: showDriverDetailViewController
        )
        let viewController = dependencies.makeDriverListViewController(flowAction: flowAction)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showDriverDetailViewController(driver: DriverModel) {
        let flowAction = DriverDetailFlowAction(
            backButtonTapped: popViewController
        )
        let viewController = dependencies.makeDriverDetailViewController(driver: driver, flowAction: flowAction)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showRaceListViewController() {
        let flowAction = RaceListFlowAction(
            backButtonTapped: popViewController,
            raceSelected: showRaceDetailViewController
        )
        let viewController = dependencies.makeRaceListViewController(flowAction: flowAction)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showRaceDetailViewController(race: RaceModel) {
        let flowAction = RaceDetailFlowAction(backButtonTapped: popViewController)
        let viewController = dependencies.makeRaceDetailViewController(race: race, flowAction: flowAction)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
}
