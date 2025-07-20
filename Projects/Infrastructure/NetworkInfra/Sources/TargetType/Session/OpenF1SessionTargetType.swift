//
//  OpenF1SessionTargetType.swift
//  NetworkInfra
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import Moya

public enum OpenF1SessionTargetType {
    case carData(
        sessionKey: Int,
        driverNumber: Int? = nil
    )
    case positions(
        sessionKey: Int,
        driverNumber: Int? = nil
    )
    case sessions(
        year: Int? = nil,
        sessionType: String? = nil
    )
}

extension OpenF1SessionTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "https://api.openf1.org")!
    }
    
    public var path: String {
        switch self {
        case .carData:
            return "/v1/car_data"
        case .positions:
            return "/v1/positions"
        case .sessions:
            return "/v1/sessions"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .carData:
            return .get
        case .positions:
            return .get
        case .sessions:
            return .get
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .carData:
            return nil
        case .positions:
            return nil
        case .sessions:
            return nil
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case let .carData(sessionKey, driverNumber):
            var parameters: [String: Any] = [
                "session_key": sessionKey
            ]
            if let driverNumber = driverNumber {
                parameters["driver_number"] = driverNumber
            }
            return parameters
        case let .positions(sessionKey, driverNumber):
            var parameters: [String: Any] = [
                "session_key": sessionKey
            ]
            if let driverNumber = driverNumber {
                parameters["driver_number"] = driverNumber
            }
            return parameters
        case let .sessions(year, sessionType):
            var parameters: [String: Any] = [:]
            if let year = year {
                parameters["year"] = year
            }
            if let sessionType = sessionType {
                parameters["session_type"] = sessionType
            }
            return parameters
        }
    }
    
    public var task: Moya.Task {
        switch method {
        case .get:
            if let parameters = parameters {
                return .requestParameters(
                    parameters: parameters,
                    encoding: URLEncoding.queryString
                )
            }
        default:
            if let parameters = parameters {
                return .requestParameters(
                    parameters: parameters,
                    encoding: JSONEncoding.default
                )
            }
        }
        return .requestPlain
    }
}

extension OpenF1SessionTargetType {
    public var sampleData: Data {
        switch self {
        case .carData:
            return Data(
                """
                """.utf8
            )
        case .positions:
            return Data(
                """
                """.utf8
            )
        case .sessions:
            return Data(
                """
                """.utf8
            )
        }
    }
}
