//
//  RaceListReactor.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import ReactorKit

import BasePresentation
import BaseDomain

public struct RaceListFlowAction {
    let backButtonTapped: () -> Void
    let raceSelected: (RaceModel) -> Void
    
    public init(
        backButtonTapped: @escaping () -> Void,
        raceSelected: @escaping (RaceModel) -> Void
    ) {
        self.backButtonTapped = backButtonTapped
        self.raceSelected = raceSelected
    }
}

enum RaceListError: Error {
    case racesNotFound
}

public final class RaceListReactor: Reactor {
    
    public enum Action {
        case viewDidLoad
        case backButtonTapped
        case raceSelected(RaceModel)
    }
    
    public enum Mutation {
        case setRaces([RaceModel])
        case setError(Error)
    }
    
    public struct State {
        @Pulse var races: [RaceModel]?
        @Pulse var error: RaceListError?
    }
    
    public var initialState = State()
    private let flowAction: RaceListFlowAction
    private let raceUseCase: RaceUseCase
    private let disposeBag = DisposeBag()
    
    public init(
        flowAction: RaceListFlowAction,
        raceUseCase: RaceUseCase
    ) {
        self.flowAction = flowAction
        self.raceUseCase = raceUseCase
    }
    
    private func handle(_ error: Error) -> RaceListError? {
        guard let raceListError = error as? RaceListError else { return nil }
        return raceListError
    }
}

// MARK: - React
extension RaceListReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let races = raceUseCase.loadRaces(year: 2025)
                .asObservable()
                .map { $0.map { RaceModel(race: $0) } }
                .map { Mutation.setRaces($0) }
                .catch { .just(.setError($0)) }
            return races
            
        case .backButtonTapped:
            flowAction.backButtonTapped()
            return .empty()
            
        case let .raceSelected(race):
            flowAction.raceSelected(race)
            return .empty()
        }
    }
    
    public func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var state = state
        switch mutation {
        case let .setRaces(races):
            state.races = races
        case let .setError(error):
            state.error = handle(error)
        }
        return state
    }
}