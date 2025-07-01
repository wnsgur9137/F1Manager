//
//  ApplicationNetworkType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 6/30/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct ApplicationNetworkType: NetworkType {
    typealias T = ApplicationTargetType
    let provider: NetworkProvider<T>
    
    static func defaultNetworking(baseURL: String) -> ApplicationNetworkType {
        return ApplicationNetworkType(
            provider: NetworkProvider(
                endpointClosure: ApplicationNetworkType.endpointsClosure(baseURL: baseURL),
                requestClosure: ApplicationNetworkType.endpointResolver(),
                stubClosure: ApplicationNetworkType.APIKeysBasedStubBehaviour,
                plugins: plugins
            )
        )
    }
    
    static func stubbingNetworking(
        baseURL: String,
        needFail: Bool
    ) -> ApplicationNetworkType {
        if needFail {
            return ApplicationNetworkType(
                provider: NetworkProvider(
                    endpointClosure: failEndPointsClosure(baseURL: baseURL),
                    requestClosure: ApplicationNetworkType.endpointResolver(),
                    stubClosure: MoyaProvider.immediatelyStub
                )
            )
        }
        return ApplicationNetworkType(
            provider: NetworkProvider(
                endpointClosure: endpointsClosure(baseURL: baseURL),
                requestClosure: ApplicationNetworkType.endpointResolver(),
                stubClosure: MoyaProvider.immediatelyStub
            )
        )
    }
}
