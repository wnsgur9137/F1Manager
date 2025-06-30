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
    
    static func defaultNetworking(
        baseURL: String
    ) -> ApplicationNetworkType {
        let provider = NetworkProvider(
            endpointClosure: ApplicationNetworkType.endpointClosure(baseURL: baseURL),
            requestClosure: ApplicationNetworkType.endpointResolver(),
            stubClosure: ApplicationNetworkType.APIKeysBasedStubBehaviour,
            plugins: plugins
        )
        return ApplicationNetworkType(provider: provider)
    }
    
    static func stubbingNetworking(
        baseURL: String,
        needFaile: Bool
    ) -> ApplicationNetworkType {
        if needFail {
            let provider = NetworkProvider(
                endpointClosure: failEndPointsClosure(baseURL: baseURL),
                requestClosure: ApplicationNetworkType.endpointResolver(),
                stubClosure: MoyaProvider.immediatelyStub
            )
            return ApplicationNetworkType(provider: provider)
        }
        let provider = NetworkProvider(
            endpointClosure: endpointsClosure(baseURL: baseURL),
            requestClosure: ApplicationNetworkType.endpointResolver(),
            stubClosure: MoyaProvider.immediatelyStub
        )
        return ApplicationNetworkType(provider: provider)
    }
}
