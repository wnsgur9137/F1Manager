//
//  OpenF1DriverTargetType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import Moya

public enum OpenF1DriverTargetType {
    case getDriver(driverNumber: Int)
}

extension OpenF1DriverTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "https://api.openf1.org")!
    }
    
    public var path: String {
        switch self {
        case .getDriver: return "/v1/drivers"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDriver: return .get
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getDriver:
            return nil
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getDriver(let driverNumber):
            return [
                "driver_number": driverNumber,
                "meeting_key": "latest"
            ]
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

extension OpenF1DriverTargetType {
    public var sampleData: Data {
        switch self {
        case let .getDriver(driverNumber):
            return Data(
                """
                [
                  {
                    "broadcast_name": "M VERSTAPPEN",
                    "country_code": "NED",
                    "driver_number": 1,
                    "first_name": "Max",
                    "full_name": "Max VERSTAPPEN",
                    "headshot_url": "https://www.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/1col/image.png",
                    "last_name": "Verstappen",
                    "meeting_key": 1219,
                    "name_acronym": "VER",
                    "session_key": 9158,
                    "team_colour": "3671C6",
                    "team_name": "Red Bull Racing"
                  }
                ]
                """.utf8
            )
        }
    }
}
