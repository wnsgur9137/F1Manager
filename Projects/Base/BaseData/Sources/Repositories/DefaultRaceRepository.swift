//
//  DefaultRaceRepository.swift
//  BaseData
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import BaseDomain

enum RaceNetworkError: Error {
    case raceNotFound
}

public final class DefaultRaceRepository: RaceRepository {
    
    private let networkManager: NetworkManager
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    private func handle(_ error: Error) -> Error {
        if let raceNetworkError = error as? RaceNetworkError {
            switch raceNetworkError {
            case .raceNotFound: return RaceNetworkError.raceNotFound
            }
        }
        return error
    }
}

extension DefaultRaceRepository {
    public func getRaces(year: Int) -> Single<[Race]> {
        let races = networkManager
            .getRaces(year: year)
            .catch { error in
                return Single.error(self.handle(error))
            }
        let domain = races.map { $0.map { $0.toDomain() } }
        return domain
    }
    
    public func getRound(
        year: Int,
        round: Int
    ) -> Single<[Race]> {
        let races = networkManager
            .getRound(
                year: year,
                round: round
            )
            .catch { error in
                return Single.error(self.handle(error))
            }
        let domain = races.map { $0.map { $0.toDomain() } }
        return domain
    }
    
    public func getRaceDriver(driverName: String) -> Single<[Race]> {
        let races = networkManager
            .getRaceDriver(driverName: driverName)
            .catch { error in
                return Single.error(self.handle(error))
            }
        let domain = races.map { $0.map { $0.toDomain() } }
        return domain
    }
    
    public func getRaceConstructor(constructorName: String) -> Single<[Race]> {
        let races = networkManager
            .getRaceConstructor(constructorName: constructorName)
            .catch { error in
                return Single.error(self.handle(error))
            }
        let domain = races.map { $0.map { $0.toDomain() } }
        return domain
    }
    
    public func getRaceGrid(gridPosition: Int) -> Single<[Race]> {
        let races = networkManager
            .getRaceGrid(gridPosition: gridPosition)
            .catch { error in
                return Single.error(self.handle(error))
            }
        let domain = races.map { $0.map { $0.toDomain() } }
        return domain
    }
    
    public func getRaceStatus(statusId: Int) -> Single<[Race]> {
        let races = networkManager
            .getRaceStatus(statusId: statusId)
            .catch { error in
                return Single.error(self.handle(error))
            }
        let domain = races.map { $0.map { $0.toDomain() } }
        return domain
    }
}
