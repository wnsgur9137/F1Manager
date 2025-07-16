//
//  DefaultDriverRepository.swift
//  BaseData
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import BaseDomain

enum DriverNetworkError: Error {
    case driverNotFound
}

public final class DefaultDriverRepository: DriverRepository {
    
    private let networkManager: NetworkManager
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    private func handle(_ error: Error) -> Error {
        if let driverNetworkError = error as? DriverNetworkError {
            switch driverNetworkError {
            case .driverNotFound: return DriverError.driverNotFound
            }
        }
        return error
    }
    
    public func getDriverDetail(driverNumber: Int) -> Single<DriverDetail> {
        let driverDTO = networkManager.getDriver(driverNumber: driverNumber)
        return driverDTO.map { $0.toDomain() }
    }
}
