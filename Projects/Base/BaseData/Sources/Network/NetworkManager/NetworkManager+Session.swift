//
//  NetworkManager+Session.swift
//  BaseData
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya

import NetworkInfra

extension NetworkManager {
    func getCarData(
        sessionKey: Int,
        driverNumber: Int?
    ) -> Single<[CarDataResponseDTO]> {
        return request(
            .carData(
                sessionKey: sessionKey,
                driverNumber: driverNumber
            ),
            type: [CarDataResponseDTO].self
        )
    }
    
    func getPositions(
        sessionKey: Int,
        driverNumber: Int?
    ) -> Single<[PositionResponseDTO]> {
        return request(
            .positions(
                sessionKey: sessionKey,
                driverNumber: driverNumber
            ),
            type: [PositionResponseDTO].self
        )
    }
    
    func getSession(
        year: Int?,
        sessionType: String?
    ) -> Single<[SessionResponseDTO]> {
        return request(
            .sessions(
                year: year,
                sessionType: sessionType
            ),
            type: [SessionResponseDTO].self
        )
    }
}
