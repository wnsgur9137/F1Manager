//
//  OpenF1DriverNetworkType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct OpenF1DriverNetworkType: NetworkType {
    typealias T = OpenF1DriverTargetType
    let provider: NetworkProvider<T>
    
    static func defaultNetworking(baseURL: String) -> OpenF1DriverNetworkType {
        return OpenF1DriverNetworkType(provider: NetworkProvider(
            endpointClosure: OpenF1DriverNetworkType.endpointsClosure(baseURL: baseURL),
            requestClosure: OpenF1DriverNetworkType.endpointResolver(),
            stubClosure: OpenF1DriverNetworkType.APIKeysBasedStubBehaviour,
            plugins: plugins
        ))
    }
    
    static func stubbingNetworking(
        baseURL: String,
        needFail: Bool
    ) -> OpenF1DriverNetworkType {
        if needFail {
            return OpenF1DriverNetworkType(provider: NetworkProvider(
                endpointClosure: failEndPointsClosure(baseURL: baseURL),
                requestClosure: OpenF1DriverNetworkType.endpointResolver(),
                stubClosure: MoyaProvider.immediatelyStub
            ))
        }
        return OpenF1DriverNetworkType(provider: NetworkProvider(
            endpointClosure: endpointsClosure(baseURL: baseURL),
            requestClosure: OpenF1DriverNetworkType.endpointResolver(),
            stubClosure: MoyaProvider.immediatelyStub
        ))
    }
}
