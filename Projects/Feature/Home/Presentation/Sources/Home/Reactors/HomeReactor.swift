//
//  HomeReactor.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import ReactorKit

import BasePresentation
import BaseDomain

public struct HomeFlowAction {
    let navigateToDriverList: () -> Void
    let driverSelected: (DriverModel) -> Void
    
    public init(
        navigateToDriverList: @escaping () -> Void,
        driverSelected: @escaping (DriverModel) -> Void
    ) {
        self.navigateToDriverList = navigateToDriverList
        self.driverSelected = driverSelected
    }
}

enum HomeError: Error {
    case driverNotFound
}

public final class HomeReactor: Reactor {
    
    public enum Action {
        case viewDidLoad
        case navigateToDriverList
        case driverSelected(DriverModel)
    }
    
    public enum Mutation {
        case setDrivers([DriverModel])
        case setError(Error)
    }
    
    public struct State {
        @Pulse var drivers: [DriverModel]?
        @Pulse var error: HomeError?
    }
    
    public var initialState = State()
    private let flowAction: HomeFlowAction
    private let driverUseCase: DriverUseCase
    private let disposeBag = DisposeBag()
    
    public init(
        flowAction: HomeFlowAction,
        driverUseCase: DriverUseCase
    ) {
        self.flowAction = flowAction
        self.driverUseCase = driverUseCase
    }
    
    private func handle(_ error: Error) -> HomeError? {
        guard let homeError = error as? HomeError else { return nil }
        return homeError
    }
}

// MARK: - React
extension HomeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let drivers = driverUseCase.getDrivers(year: 2025)
                .asObservable()
                .map { $0.map { DriverModel(driver: $0) } }
                .map { Mutation.setDrivers($0) }
                .catch { .just(.setError($0)) }
            return drivers
            
        case .navigateToDriverList:
            flowAction.navigateToDriverList()
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
        case let .setError(error):
            state.error = handle(error)
        }
        return state
    }
}
