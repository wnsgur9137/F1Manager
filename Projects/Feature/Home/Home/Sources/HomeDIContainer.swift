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
    
    private func makeHomeReactor(flowAction: HomeFlowAction) -> HomeReactor {
        let useCase = makeDriverUseCase()
        let reactor = HomeReactor(
            flowAction: flowAction,
            driverUseCase: useCase
        )
        return reactor
    }
    
    public func makeHomeViewController(flowAction: HomeFlowAction) -> HomeViewController {
        let reactor = makeHomeReactor(flowAction: flowAction)
        let viewController = HomeViewController.create(with: reactor)
        return viewController
    }
}
