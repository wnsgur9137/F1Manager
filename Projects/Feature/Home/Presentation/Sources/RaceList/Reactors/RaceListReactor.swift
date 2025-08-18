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
    
    public enum RaceFilter: Int, CaseIterable {
        case allRaces = 0
        case upcoming = 1
        case completed = 2
        
        func title() -> String {
            switch self {
            case .allRaces:
                return "All Races"
            case .upcoming:
                return "Upcoming"
            case .completed:
                return "Completed"
            }
        }
    }
    
    public enum Action {
        case viewDidLoad
        case backButtonTapped
        case filterChanged(Int)
        case raceSelectedAt(IndexPath)
    }
    
    public enum Mutation {
        case setRaces([RaceModel])
        case setError(Error)
        case setCurrentFilter(RaceFilter)
    }
    
    public struct State {
        @Pulse var raceFilters: [RaceFilter]?
        @Pulse var currentRaceFilter: RaceFilter = .upcoming
        @Pulse var racesDidUpdate: Void?
        @Pulse var error: RaceListError?
    }
    
    public var initialState = State()
    private let flowAction: RaceListFlowAction
    private let raceUseCase: RaceUseCase
    private let disposeBag = DisposeBag()
    
    private var races = [RaceModel]()
    private var filteredRaces = [RaceModel]()
    
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
            
        case let .filterChanged(index):
            guard let filter = RaceFilter(rawValue: index) else { return .empty() }
            return .just(.setCurrentFilter(filter))
            
        case let .raceSelectedAt(indexPath):
            guard let race = filteredRaces[safe: indexPath.row] else { return .empty() }
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
            self.races = races
            self.apply(filter: .upcoming)
            state.raceFilters = RaceFilter.allCases
            state.currentRaceFilter = .upcoming
            state.racesDidUpdate = Void()
        case let .setError(error):
            state.error = handle(error)
        case let .setCurrentFilter(filter):
            self.apply(filter: filter)
            state.currentRaceFilter = filter
            state.racesDidUpdate = Void()
        }
        return state
    }
}

// MARK: - RaceListDataSource
extension RaceListReactor: RaceListDataSource {
    func numberOfRows(in section: Int) -> Int {
        return filteredRaces.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> RaceModel? {
        return filteredRaces[safe: indexPath.row]
    }
}

// MARK: - Helper Methods
extension RaceListReactor {
    private func apply(filter: RaceFilter) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        switch filter {
        case .allRaces:
            filteredRaces = races
        case .upcoming:
            filteredRaces = races.filter { race in
                guard let raceDate = dateFormatter.date(from: race.date) else { return false }
                return Calendar.current.compare(raceDate, to: currentDate, toGranularity: .day) != .orderedAscending
            }
        case .completed:
            filteredRaces = races.filter { race in
                guard let raceDate = dateFormatter.date(from: race.date) else { return false }
                return Calendar.current.compare(raceDate, to: currentDate, toGranularity: .day) == .orderedAscending
            }
        }
    }
}
