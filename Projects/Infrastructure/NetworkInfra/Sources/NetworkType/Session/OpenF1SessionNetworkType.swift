//
//  OpenF1SessionNetworkType.swift
//  NetworkInfra
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct OpenF1SessionNetworkType: NetworkType {
    typealias T = OpenF1SessionTargetType
    let provider: NetworkProvider<T>
    
    static func defaultNetworking(baseURL: String) -> OpenF1SessionNetworkType {
        return OpenF1SessionNetworkType(provider: NetworkProvider(
            endpointClosure: OpenF1SessionNetworkType.endpointsClosure(baseURL: baseURL),
            requestClosure: OpenF1SessionNetworkType.endpointResolver(),
            stubClosure: OpenF1SessionNetworkType.APIKeysBasedStubBehaviour,
            plugins: plugins
        ))
    }
    
    static func stubbingNetworking(
        baseURL: String,
        needFail: Bool
    ) -> OpenF1SessionNetworkType {
        if needFail {
            return OpenF1SessionNetworkType(provider: NetworkProvider(
                endpointClosure: failEndPointsClosure(baseURL: baseURL),
                requestClosure: DriverNetworkType.endpointResolver(),
                stubClosure: MoyaProvider.immediatelyStub
            ))
        }
        return OpenF1SessionNetworkType(provider: NetworkProvider(
            endpointClosure: endpointsClosure(baseURL: baseURL),
            requestClosure: OpenF1SessionNetworkType.endpointResolver(),
            stubClosure: MoyaProvider.immediatelyStub
        ))
    }
}
