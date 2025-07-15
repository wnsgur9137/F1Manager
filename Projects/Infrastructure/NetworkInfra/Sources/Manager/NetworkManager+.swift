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

public extension NetworkManager {
    func request(_ target: DriverTargetType) -> Single<Any> {
        return driverProvider
            .request(target)
            .mapJSON()
            .catch { error in
                print("🚨 request error: \(error)")
                return .error(error)
            }
    }
    
    func request<T: Decodable>(
        _ target: DriverTargetType,
        type: T.Type
    ) -> Single<T> {
        return driverProvider
            .request(target)
            .map(T.self, using: JSONDecoder())
            .catch { error in
                print("🚨 request error: \(error)")
                return .error(error)
            }
    }
}
