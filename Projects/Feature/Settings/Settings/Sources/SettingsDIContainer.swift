//
//  SettingsDIContainer.swift
//  Settings
//
//  Created by JunHyeok Lee on 9/8/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import NetworkInfra
import SettingsData
import SettingsDomain
import SettingsPresentation
import BaseData
import BaseDomain
import BasePresentation

public final class SettingsDIContainer: DIContainer {
    
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
}

extension SettingsDIContainer: SettingsCoordinatorDependencies {
}
