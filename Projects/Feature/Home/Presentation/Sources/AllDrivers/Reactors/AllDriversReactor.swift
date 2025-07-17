//
//  AllDriversReactor.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import BasePresentation

public struct AllDriversFlowAction {
    let backButtonTapped: () -> Void
    let driverSelected: (DriverModel) -> Void
    
    public init(
        backButtonTapped: @escaping () -> Void,
        driverSelected: @escaping (DriverModel) -> Void
    ) {
        self.backButtonTapped = backButtonTapped
        self.driverSelected = driverSelected
    }
}

enum AllDriversError: Error {
    case driversNotFound
    case networkError
}

public final class AllDriversReactor: Reactor {
    
    public enum Action {
        case viewDidLoad
        case backButtonTapped
        case driverSelected(DriverModel)
        case refreshDrivers
    }
    
    public enum Mutation {
        case setDrivers([DriverModel])
        case setLoading(Bool)
        case setError(Error)
    }
    
    public struct State {
        @Pulse var drivers: [DriverModel]?
        @Pulse var isLoading: Bool?
        @Pulse var error: AllDriversError?
    }
    
    public var initialState = State()
    private let flowAction: AllDriversFlowAction
    private let driverUseCase: DriverUseCase
    private let disposeBag = DisposeBag()
    
    public init(
        flowAction: AllDriversFlowAction,
        driverUseCase: DriverUseCase
    ) {
        self.flowAction = flowAction
        self.driverUseCase = driverUseCase
    }
    
    private func handle(_ error: Error) -> AllDriversError? {
        guard let allDriversError = error as? AllDriversError else {
            return .networkError
        }
        return allDriversError
    }
}

// MARK: - React
extension AllDriversReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad, .refreshDrivers:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                driverUseCase.getDrivers(year: 2025)
                    .asObservable()
                    .flatMap { drivers -> Observable<Mutation> in
                        return Observable.concat([
                            Observable.just(.setLoading(false)),
                            Observable.just(.setDrivers(drivers))
                        ])
                    }
                    .catch { error in
                        return Observable.concat([
                            Observable.just(.setLoading(false)),
                            Observable.just(.setError(error))
                        ])
                    }
            ])
            
        case .backButtonTapped:
            flowAction.backButtonTapped()
            return .empty()
            
        case let .driverSelected(driver):
            flowAction.driverSelected(driver)
            return .empty()
        }
    }
    
    public func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var state = state
        switch mutation {
        case let .setDrivers(drivers):
            state.drivers = drivers
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setError(error):
            state.error = handle(error)
        }
        return state
    }
}
