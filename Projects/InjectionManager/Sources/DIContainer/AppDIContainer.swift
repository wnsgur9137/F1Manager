//
//  AppDIContainer.swift
//  InjectionManager
//
//  Created by JUNHYEOK LEE on 6/22/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import NetworkInfra

public final class AppDIContainer {
    
    public lazy var appConfiguration = AppConfiguration()
    
    public init() { }
    
    public func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies()
        return MainSceneDIContainer(dependencies: dependencies)
    }
}
