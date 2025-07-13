//
//  SceneDelegate.swift
//  F1Manager
//
//  Created by JUNHYEOK LEE on 6/21/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

import InjectionManager

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let appDIContainer = AppDIContainer()
    private var appFlowCoordinator: AppFlowCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let rootNavigationController = UINavigationController()
        rootNavigationController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = rootNavigationController
        appFlowCoordinator = AppFlowCoordinator(
            rootNavigationController: rootNavigationController,
            appDIContainer: appDIContainer
        )
//        appFlowCoordinator?.startSplash()
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
        return
    }
    
    
}
