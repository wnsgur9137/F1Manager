//
//  NetworkManager+.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya

// MARK: - Driver
public extension NetworkManager {
    func request(_ target: DriverTargetType) -> Single<Any> {
        return driverProvider
            .request(target)
            .mapJSON()
    }
    
    func request<T: Decodable>(
        _ target: DriverTargetType,
        type: T.Type
    ) -> Single<T> {
        return driverProvider
            .request(target)
            .map(T.self, using: JSONDecoder())
    }
}

// MARK: - OpenF1Driver
public extension NetworkManager {
    func request(_ target: OpenF1DriverTargetType) -> Single<Any> {
        return openF1DriverProvider
            .request(target)
            .mapJSON()
    }
    
    func request<T: Decodable>(
        _ target: OpenF1DriverTargetType,
        type: T.Type
    ) -> Single<T> {
        return openF1DriverProvider
            .request(target)
            .map(T.self, using: JSONDecoder())
    }
}

// MARK: - Race
public extension NetworkManager {
    func request(_ target: RaceTargetType) -> Single<Any> {
        return raceProvider
            .request(target)
            .mapJSON()
    }
    
    func request<T: Decodable>(
        _ target: RaceTargetType,
        type: T.Type
    ) -> Single<T> {
        return raceProvider
            .request(target)
            .map(T.self, using: JSONDecoder())
    }
}
