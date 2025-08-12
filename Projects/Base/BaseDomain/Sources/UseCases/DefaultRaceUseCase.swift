//
//  DefaultRaceUseCase.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift

public enum RaceError: Error {
    case raceNotFound
}

public protocol RaceUseCase {
    func loadRaces(year: Int) -> Single<[Race]>
    func loadRound(year: Int, round: Int) -> Single<[Race]>
    func loadRaceDriver(driverName: String) -> Single<[Race]>
    func loadRaceConstructor(constructorName: String) -> Single<[Race]>
    func loadRaceGrid(gridPosition: Int) -> Single<[Race]>
    func loadRaceStatus(statusId: Int) -> Single<[Race]>
}

public final class DefaultRaceUseCase: RaceUseCase {
    
    private let repository: RaceRepository
    
    public init(repository: RaceRepository) {
        self.repository = repository
    }
    
    private func handle(_ error: Error) -> Error {
        if let raceError = error as? RaceError {
            switch raceError {
            case .raceNotFound: return raceError
            }
        }
        return error
    }
    
    public func loadRaces(year: Int) -> Single<[Race]> {
        return repository
            .getRaces(year: year)
            .catch { error in
                return Single.error(self.handle(error))
            }
    }
    
    public func loadRound(year: Int, round: Int) -> Single<[Race]> {
        return repository
            .getRound(
                year: year,
                round: round
            )
            .catch { error in
                return Single.error(self.handle(error))
            }
    }
    
    public func loadRaceDriver(driverName: String) -> Single<[Race]> {
        return repository
            .getRaceDriver(driverName: driverName)
            .catch { error in
                return Single.error(self.handle(error))
            }
    }
    
    public func loadRaceConstructor(constructorName: String) -> Single<[Race]> {
        return repository
            .getRaceConstructor(constructorName: constructorName)
            .catch { error in
                return Single.error(self.handle(error))
            }
    }
    
    public func loadRaceGrid(gridPosition: Int) -> Single<[Race]> {
        return repository
            .getRaceGrid(gridPosition: gridPosition)
            .catch { error in
                return Single.error(self.handle(error))
            }
    }
    
    public func loadRaceStatus(statusId: Int) -> Single<[Race]> {
        return repository
            .getRaceStatus(statusId: statusId)
            .catch { error in
                return Single.error(self.handle(error))
            }
    }
}
