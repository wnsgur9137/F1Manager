//
//  DriverDetailReactor.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import BasePresentation

public struct DriverDetailFlowAction {
    let backButtonTapped: () -> Void
    
    public init(
        backButtonTapped: @escaping () -> Void
    ) {
        self.backButtonTapped = backButtonTapped
    }
}

enum DriverDetailError: Error {
    case driverNotFound
    case invalidDriverData
}

public final class DriverDetailReactor: Reactor {
    
    public enum Action {
        case viewDidLoad
        case backButtonTapped
    }
    
    public enum Mutation {
        case setDriver(DriverModel)
        case setError(Error)
    }
    
    public struct State {
        @Pulse var driver: DriverModel?
        @Pulse var error: DriverDetailError?
    }
    
    public var initialState = State()
    private let flowAction: DriverDetailFlowAction
    private let driver: DriverModel
    private let disposeBag = DisposeBag()
    
    public init(
        driver: DriverModel,
        flowAction: DriverDetailFlowAction
    ) {
        self.driver = driver
        self.flowAction = flowAction
    }
    
    private func handle(_ error: Error) -> DriverDetailError? {
        guard let driverDetailError = error as? DriverDetailError else {
            return .invalidDriverData
        }
        return driverDetailError
    }
}

// MARK: - React
extension DriverDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.just(.setDriver(driver))
            
        case .backButtonTapped:
            flowAction.backButtonTapped()
            return .empty()
        }
    }
    
    public func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var state = state
        switch mutation {
        case let .setDriver(driver):
            state.driver = driver
        case let .setError(error):
            state.error = handle(error)
        }
        return state
    }
}