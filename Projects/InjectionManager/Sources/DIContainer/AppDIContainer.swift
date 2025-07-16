//
//  AppDIContainer.swift
//  InjectionManager
//
//  Created by JUNHYEOK LEE on 6/22/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

import NetworkInfra
import Features

public final class AppDIContainer {
    
    public lazy var appConfiguration = AppConfiguration()
    
    private lazy var mainTabBarController = MainTabBarController()
    
    private lazy var networkManager: NetworkManager = {
        return NetworkManager(
            withTest: false,
            withFail: false,
            baseURL: "",
            jolpiBaseURL: "https://api.jolpi.ca/ergast/f1",
            openF1BaseURL: "https://api.openf1.org"
        )
    }()
    
    public init() { }
    
    public func makeMainSceneDIContainer(rootNavigationController: UINavigationController) -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies(
            networkManager: networkManager
        )
        return MainSceneDIContainer(
            rootNavigationController: rootNavigationController,
            tabBarController: mainTabBarController,
            dependencies: dependencies
        )
    }
}
