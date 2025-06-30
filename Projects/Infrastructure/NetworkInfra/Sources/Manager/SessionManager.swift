//
//  DefaultAlamofireSessionManager.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 6/30/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import Alamofire

final class DefaultAlamofireSessionManager: Alamofire.Session {
    static let shared: DefaultAlamofireSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForRequest = 10
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireSessionManager(configuration: configuration)
    }()
}
