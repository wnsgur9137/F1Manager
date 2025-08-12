//
//  RaceNetworkType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct RaceNetworkType: NetworkType {
    typealias T = RaceTargetType
    let provider: NetworkProvider<T>
    
    static func defaultNetworking(baseURL: String) -> RaceNetworkType {
        return RaceNetworkType(provider: NetworkProvider(
            endpointClosure: RaceNetworkType.endpointsClosure(baseURL: baseURL),
            requestClosure: RaceNetworkType.endpointResolver(),
            stubClosure: RaceNetworkType.APIKeysBasedStubBehaviour,
            plugins: plugins
        ))
    }
    
    static func stubbingNetworking(
        baseURL: String,
        needFail: Bool
    ) -> RaceNetworkType {
        if needFail {
            return RaceNetworkType(provider: NetworkProvider(
                endpointClosure: failEndPointsClosure(baseURL: baseURL),
                requestClosure: RaceNetworkType.endpointResolver(),
                stubClosure: MoyaProvider.immediatelyStub
            ))
        }
        return RaceNetworkType(provider: NetworkProvider(
            endpointClosure: endpointsClosure(baseURL: baseURL),
            requestClosure: RaceNetworkType.endpointResolver(),
            stubClosure: MoyaProvider.immediatelyStub
        ))
    }
}
