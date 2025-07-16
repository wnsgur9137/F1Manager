//
//  NetworkManager+Driver.swift
//  BaseData
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya

import NetworkInfra

extension NetworkManager {
    func getDrivers(year: Int) -> Single<[DriverResponseDTO]> {
        return request(
            .getDrivers(year: year),
            type: DriversResponseDTO.self
        )
        .map {
            print("😢$0.drivers: \($0.drivers)")
            return $0.drivers
        }
    }
    
    func getDriverDetail(driverNumber: Int) -> Single<DriverDetailResponseDTO> {
        return request(
            .getDriver(driverNumber: driverNumber),
            type: [DriverDetailResponseDTO].self
        )
        .flatMap { drivers in
            print("🛰️ drivers: \(drivers)")
            guard let driver = drivers.first else {
                return .error(DriverNetworkError.driverNotFound)
            }
            return .just(driver)
        }
    }
}
