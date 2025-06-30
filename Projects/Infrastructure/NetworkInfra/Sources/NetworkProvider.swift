//
//  NetworkProvider.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 6/30/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import RxMoya
import Moya

final class NetworkProvider<Target> where Target: MoyaErrorHandleable {
    fileprivate let provider: MoyaProvider<Target>
    
    init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
        session: Session = DefaultAlamofireSessionManager.shared,
        plugins: [PluginType] = [],
        trackInflights: Bool = false
    ) {
        self.provider = MoyaProvider(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
}

extension NetworkProvider {
    func request(_ route: Target) -> Single<Moya.Response> {
        return provider.rx.request(route)
            .filterSuccessfulStatusCodes()
            .catch(route.internetConnection)
            .catch(route.timeOut)
            .catch(route.tokenError)
            .catch(route.rest)
            .do (
                onSuccess: { response in
//                    print("response: \(String(describing: String(data: response.data, encoding: .utf8)))")
                },
                onError: { rawError in
                    print("🚨ERROR - \(route.path)")
                    switch rawError {
                    case NetworkError.requestTimeOut:
                        print("NetworkError: TimedOut")
                    case NetworkError.internetConnection:
                        print("NetworkError: internetConnection")
                    case let NetworkError.rest(error, statusCode, errorCode, message):
                        print("NetworkError: rest(\(error)")
                        print("\tError: \(error.localizedDescription)")
                        print("\tStatusCode: \(statusCode ?? 0)")
                        print("\tErrorCode: \(errorCode ?? "null")")
                        print("\tMessage: \(message ?? "null")")
                    default:
                        break
                    }
                }
            )
            .retry(2)
    }
}
