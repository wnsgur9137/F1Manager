//
//  DefaultDriverUseCase.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift

public enum DriverError: Error {
    case driverNotFound
}

public protocol DriverUseCase {
    func getDrivers(year: Int) -> Single<[Driver]>
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
    
    public func getDrivers(year: Int) -> Single<[Driver]> {
        let driverEntities = repository.getDrivers(year: year)
        return driverEntities
            .catch { error in
                return .error(self.handle(error))
            }
    }
}
