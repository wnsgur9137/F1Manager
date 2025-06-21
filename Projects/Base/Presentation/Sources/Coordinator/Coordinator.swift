//
//  Coordinator.swift
//  BasePresentation
//
//  Created by JUNHYEOK LEE on 6/22/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

public enum CoordinatorType {
    case splash
    case onboarding
    case home
}

public protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigtaionController: UINavigationController? { get set }
    var childCoordinator: [Coordinator] { get set }
    var type: CoordinatorType { get }
    
    func starat()
    func finish()
}

public extension Coordinator {
    func finish() {
        childCoordinator.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

public protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
