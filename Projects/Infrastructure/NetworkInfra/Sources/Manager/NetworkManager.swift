//
//  NetworkManager.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 6/30/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public final class NetworkManager {
    let applicationProvider: ApplicationNetworkType
    let driverProvider: DriverNetworkType
    
    public init(
        withTest: Bool,
        withFail: Bool,
        baseURL: String
    ) {
        if withTest {
            self.applicationProvider = .stubbingNetworking(baseURL: baseURL, needFail: withFail)
            self.driverProvider = .stubbingNetworking(baseURL: baseURL, needFail: withFail)
        } else {
            self.applicationProvider = .defaultNetworking(baseURL: baseURL)
            self.driverProvider = .defaultNetworking(baseURL: baseURL)
        }
    }
}
