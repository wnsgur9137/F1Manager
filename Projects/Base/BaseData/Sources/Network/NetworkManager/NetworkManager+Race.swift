//
//  NetworkManager+Race.swift
//  BaseData
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya

import NetworkInfra

extension NetworkManager {
    func getRaces(year: Int) -> Single<[RaceResponseDTO]> {
        return request(
            .getRaces(year: year),
            type: RacesResponseDTO.self
        )
        .map { $0.races }
    }
    
    func getRound(year: Int, round: Int) -> Single<[RaceResponseDTO]> {
        return request(
            .getRound(
                year: year,
                round: round
            ),
            type: RacesResponseDTO.self
        )
        .map { $0.races }
    }
    
    func getRaceDriver(driverName: String) -> Single<[RaceResponseDTO]> {
        return request(
            .getRaceDriver(driverName: driverName),
            type: RacesResponseDTO.self
        )
        .map { $0.races }
    }
    
    func getRaceConstructor(constructorName: String) -> Single<[RaceResponseDTO]> {
        return request(
            .getRaceConstructor(constructorName: constructorName),
            type: RacesResponseDTO.self
        )
        .map { $0.races }
    }
    
    func getRaceGrid(gridPosition: Int) -> Single<[RaceResponseDTO]> {
        return request(
            .getRaceGrid(gridPosition: gridPosition),
            type: RacesResponseDTO.self
        )
        .map { $0.races }
    }
    
    func getRaceStatus(statusId: Int) -> Single<[RaceResponseDTO]> {
        return request(
            .getRaceStatus(statusId: statusId),
            type: RacesResponseDTO.self
        )
        .map { $0.races }
    }
}
