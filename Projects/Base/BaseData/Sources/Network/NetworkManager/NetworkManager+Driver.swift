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
    func getDriver(driverNumber: Int) -> Single<DriverResponseDTO> {
        return request(
            .getDriver(driverNumber: driverNumber),
            type: [DriverResponseDTO].self
        )
        .flatMap { drivers in
            guard let driver = drivers.first else {
                return .error(DriverNetworkError.driverNotFound)
            }
            return .just(driver)
        }
    }
}
