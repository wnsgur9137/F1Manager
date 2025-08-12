//
//  RaceDetailReactor.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import ReactorKit

import BasePresentation
import BaseDomain

public struct RaceDetailFlowAction {
    public init() {
        
    }
}

enum RaceDetailError: Error {
    case raceNotFound
}

public final class RaceDetailReactor: Reactor {
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setRace(RaceModel)
        case setError(Error)
    }
    
    public struct State {
        @Pulse var race: RaceModel?
        @Pulse var error: RaceDetailError?
    }
    
    public var initialState = State()
    private let flowAction: RaceDetailFlowAction
    private let race: RaceModel
    private let disposeBag = DisposeBag()
    
    public init(
        flowAction: RaceDetailFlowAction,
        race: RaceModel
    ) {
        self.flowAction = flowAction
        self.race = race
    }
    
    private func handle(_ error: Error) -> RaceDetailError? {
        guard let raceDetailError = error as? RaceDetailError else { return nil }
        return raceDetailError
    }
}

// MARK: - React
extension RaceDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setRace(race))
        }
    }
    
    public func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var state = state
        switch mutation {
        case let .setRace(race):
            state.race = race
        case let .setError(error):
            state.error = handle(error)
        }
        return state
    }
}