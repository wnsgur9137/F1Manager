//
//  DriverListReactor.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import BasePresentation
import BaseDomain

public struct DriverListFlowAction {
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

enum DriverListError: Error {
    case driversNotFound
    case networkError
}

public final class DriverListReactor: Reactor {
    
    public enum Action {
        case viewDidLoad
        case backButtonTapped
        case driverSelectedAt(IndexPath)
        case refreshDrivers
    }
    
    public enum Mutation {
        case setDrivers([DriverModel])
        case setLoading(Bool)
        case setError(Error)
    }
    
    public struct State {
        @Pulse var driversDidUpdate: Void?
        @Pulse var isLoading: Bool?
        @Pulse var error: DriverListError?
    }
    
    public var initialState = State()
    private let flowAction: DriverListFlowAction
    private let driverUseCase: DriverUseCase
    private let disposeBag = DisposeBag()
    
    private var drivers = [DriverModel]()
    
    public init(
        flowAction: DriverListFlowAction,
        driverUseCase: DriverUseCase
    ) {
        self.flowAction = flowAction
        self.driverUseCase = driverUseCase
    }
    
    private func handle(_ error: Error) -> DriverListError? {
        guard let driverListError = error as? DriverListError else {
            return .networkError
        }
        return driverListError
    }
}

// MARK: - React
extension DriverListReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad, .refreshDrivers:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                driverUseCase.getDrivers(year: 2025)
                    .asObservable()
                    .flatMap { drivers -> Observable<Mutation> in
                        let drivers = drivers.map { DriverModel(driver: $0) }
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
            
        case let .driverSelectedAt(indexPath):
            guard let driver = drivers[safe: indexPath.row] else { return .empty() }
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
            self.drivers = drivers.sorted { (first, second) in
                guard let firstPosition = first.standingPosition,
                      let secondPosition = second.standingPosition else {
                    return false
                }
                return firstPosition < secondPosition
            }
            state.driversDidUpdate = Void()
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setError(error):
            state.error = handle(error)
        }
        return state
    }
}

// MARK: - DriverListDataSource
extension DriverListReactor: DriverListDataSource {
    func numberOfRows(in section: Int) -> Int {
        return drivers.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> DriverModel? {
        return drivers[safe: indexPath.row]
    }
}
