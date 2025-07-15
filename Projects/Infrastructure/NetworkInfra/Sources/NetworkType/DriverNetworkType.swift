//
//  DriverNetworkType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct DriverNetworkType: NetworkType {
    typealias T = DriverTargetType
    let provider: NetworkProvider<T>
    
    static func defaultNetworking(baseURL: String) -> DriverNetworkType {
        return DriverNetworkType(provider: NetworkProvider(
            endpointClosure: DriverNetworkType.endpointsClosure(baseURL: baseURL),
            requestClosure: DriverNetworkType.endpointResolver(),
            stubClosure: DriverNetworkType.APIKeysBasedStubBehaviour,
            plugins: plugins
        ))
    }
    
    static func stubbingNetworking(
        baseURL: String,
        needFail: Bool
    ) -> DriverNetworkType {
        if needFail {
            return DriverNetworkType(provider: NetworkProvider(
                endpointClosure: failEndPointsClosure(baseURL: baseURL),
                requestClosure: DriverNetworkType.endpointResolver(),
                stubClosure: MoyaProvider.immediatelyStub
            ))
        }
        return DriverNetworkType(provider: NetworkProvider(
            endpointClosure: endpointsClosure(baseURL: baseURL),
            requestClosure: DriverNetworkType.endpointResolver(),
            stubClosure: MoyaProvider.immediatelyStub
        ))
    }
}
