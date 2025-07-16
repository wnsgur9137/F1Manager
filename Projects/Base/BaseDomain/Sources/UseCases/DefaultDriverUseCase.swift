//
//  DefaultDriverUseCase.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift

import BasePresentation

public enum DriverError: Error {
    case driverNotFound
}

public final class DefaultDriverUseCase: DriverUseCase {
    
    private let repository: DriverRepository
    
    public init(repository: DriverRepository) {
        self.repository = repository
    }
    
    private func handle(_ error: Error) -> Error {
        if let driverError = error as? DriverError {
            switch driverError {
            case .driverNotFound: return driverError
            }
        }
        return error
    }
    
    public func getDrivers(year: Int) -> Single<[DriverModel]> {
        let driverEntities = repository.getDrivers(year: year)
        return driverEntities
            .map { $0.map {
                print($0.toModel())
                return $0.toModel()
            } }
            .catch { error in
                return .error(self.handle(error))
            }
    }
}
