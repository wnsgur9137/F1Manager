//
//  SplashDIContainer.swift
//  Splash
//
//  Created by JunHyeok Lee on 7/21/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

import NetworkInfra
import SplashData
import SplashDomain
import SplashPresentation
import BaseData
import BaseDomain
import BasePresentation

public final class SplashDIContainer: DIContainer {
    
    public struct Dependencies {
        let networkManager: NetworkManager
        
        public init(networkManager: NetworkManager) {
            self.networkManager = networkManager
        }
    }
    
    private let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension SplashDIContainer: SplashCoordinatorDependencies {
    private func makeSplashReactor(flowAction: SplashFlowAction) -> SplashReactor {
        let reactor = SplashReactor(flowAction: flowAction)
        return reactor
    }
    
    public func makeSplashViewController(flowAction: SplashFlowAction) -> SplashViewController {
        let reactor = makeSplashReactor(flowAction: flowAction)
        let viewController = SplashViewController.create(with: reactor)
        return viewController
    }
}
