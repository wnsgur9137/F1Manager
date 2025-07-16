//
//  DriverTargetType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 7/16/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import Moya

public enum DriverTargetType {
    case getDrivers(year: Int)
}

extension DriverTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "https://api.jolpi.ca/ergast/f1")!
    }
    
    public var path: String {
        switch self {
        case let .getDrivers(year):
            return "/\(year)/drivers"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDrivers: return .get
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getDrivers:
            return nil
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getDrivers:
            return nil
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

extension DriverTargetType {
    public var sampleData: Data {
        switch self {
        case .getDrivers:
            return Data(
            """
            {
              "MRData": {
                "xmlns": "",
                "series": "f1",
                "url": "http://api.jolpi.ca/ergast/f1/drivers/",
                "limit": "30",
                "offset": "0",
                "total": "860",
                "DriverTable": {
                  "Drivers": [
                    {
                      "driverId": "abate",
                      "url": "http://en.wikipedia.org/wiki/Carlo_Mario_Abate",
                      "givenName": "Carlo",
                      "familyName": "Abate",
                      "dateOfBirth": "1932-07-10",
                      "nationality": "Italian"
                    },
                    {
                      "driverId": "abecassis",
                      "url": "http://en.wikipedia.org/wiki/George_Abecassis",
                      "givenName": "George",
                      "familyName": "Abecassis",
                      "dateOfBirth": "1913-03-21",
                      "nationality": "British"
                    },
                    ...more
                  ]
                }
              }
            }
            """.utf8
            )
        }
    }
}

