//
//  HomeDIContainer.swift
//  Home
//
//  Created by JUNHYEOK LEE on 7/13/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import NetworkInfra
import HomeData
import HomeDomain
import HomePresentation
import BaseData
import BaseDomain
import BasePresentation

public final class HomeDIContainer: DIContainer {
    
    public struct Dependencies {
        let networkManager: NetworkManager
        
        public init(networkManager: NetworkManager) {
            self.networkManager = networkManager
        }
    }
    
    private let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    private func makeDriverRepository() -> DriverRepository {
        let repository = DefaultDriverRepository(networkManager: dependencies.networkManager)
        return repository
    }
    
    private func makeDriverUseCase() -> DriverUseCase {
        let repository = makeDriverRepository()
        let useCase = DefaultDriverUseCase(repository: repository)
        return useCase
    }
}

extension HomeDIContainer: HomeCoordinatorDependencies {
    
    // MARK: - Home
    
    private func makeHomeReactor(flowAction: HomeFlowAction) -> HomeReactor {
        let driverUseCase = makeDriverUseCase()
        let reactor = HomeReactor(
            flowAction: flowAction,
            driverUseCase: driverUseCase
        )
        return reactor
    }
    
    public func makeHomeViewController(flowAction: HomeFlowAction) -> HomeViewController {
        let reactor = makeHomeReactor(flowAction: flowAction)
        let viewController = HomeViewController.create(with: reactor)
        return viewController
    }
    
    // MARK: - DriverList
    
    private func makeDriverListReactor(flowAction: DriverListFlowAction) -> DriverListReactor {
        let driverUseCase = makeDriverUseCase()
        let reactor = DriverListReactor(
            flowAction: flowAction,
            driverUseCase: driverUseCase
        )
        return reactor
    }
    
    public func makeDriverListViewController(flowAction: DriverListFlowAction) -> DriverListViewController {
        let reactor = makeDriverListReactor(flowAction: flowAction)
        let viewController = DriverListViewController.create(with: reactor)
        return viewController
    }
    
    // MARK: - DriverDetail
    
    private func makeDriverDetailReactor(
        driver: DriverModel,
        flowAction: DriverDetailFlowAction
    ) -> DriverDetailReactor {
        let driverUseCase = makeDriverUseCase()
        let reactor = DriverDetailReactor(
            driver: driver,
            flowAction: flowAction
        )
        return reactor
    }
    
    public func makeDriverDetailViewController(
        driver: DriverModel,
        flowAction: DriverDetailFlowAction
    ) -> DriverDetailViewController {
        let reactor = makeDriverDetailReactor(
            driver: driver,
            flowAction: flowAction
        )
        let viewController = DriverDetailViewController.create(with: reactor)
        return viewController
    }
    
}
