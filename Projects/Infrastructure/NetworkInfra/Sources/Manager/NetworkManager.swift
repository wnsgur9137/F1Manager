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
    let openF1DriverProvider: OpenF1DriverNetworkType
    let driverProvider: DriverNetworkType
    
    public init(
        withTest: Bool,
        withFail: Bool,
        baseURL: String,
        jolpiBaseURL: String,
        openF1BaseURL: String
    ) {
        if withTest {
            self.applicationProvider = .stubbingNetworking(baseURL: baseURL, needFail: withFail)
            self.driverProvider = .stubbingNetworking(baseURL: jolpiBaseURL, needFail: withFail)
            self.openF1DriverProvider = .stubbingNetworking(baseURL: openF1BaseURL, needFail: withFail)
        } else {
            self.applicationProvider = .defaultNetworking(baseURL: baseURL)
            self.driverProvider = .defaultNetworking(baseURL: jolpiBaseURL)
            self.openF1DriverProvider = .defaultNetworking(baseURL: openF1BaseURL)
        }
    }
}
