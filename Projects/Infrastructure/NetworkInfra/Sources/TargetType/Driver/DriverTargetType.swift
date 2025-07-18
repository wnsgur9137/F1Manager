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
    case getDriverStandings(year: Int)
}

extension DriverTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "https://api.jolpi.ca/ergast/f1")!
    }
    
    public var path: String {
        switch self {
        case let .getDrivers(year):
            return "/\(year)/drivers"
        case let .getDriverStandings(year):
            return "/\(year)/driverstandings"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDrivers: return .get
        case .getDriverStandings: return .get
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getDrivers:
            return nil
        case .getDriverStandings:
            return nil
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getDrivers:
            return nil
        case .getDriverStandings:
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
        case .getDriverStandings:
            return Data(
                """
                {
                    "MRData": {
                        "xmlns": "",
                        "series": "f1",
                        "url": "https://api.jolpi.ca/ergast/f1/2025/driverstandings/",
                        "limit": "4",
                        "offset": "0",
                        "total": "4",
                        "StandingsTable": {
                            "season": "2025",
                            "round": "12",
                            "StandingsLists": [
                                {
                                    "season": "2025",
                                    "round": "12",
                                    "DriverStandings": [
                                        {
                                            "position": "1",
                                            "positionText": "1",
                                            "points": "234",
                                            "wins": "5",
                                            "Driver": {
                                                "driverId": "piastri",
                                                "permanentNumber": "81",
                                                "code": "PIA",
                                                "url": "http://en.wikipedia.org/wiki/Oscar_Piastri",
                                                "givenName": "Oscar",
                                                "familyName": "Piastri",
                                                "dateOfBirth": "2001-04-06",
                                                "nationality": "Australian"
                                            },
                                            "Constructors": [
                                                {
                                                    "constructorId": "mclaren",
                                                    "url": "http://en.wikipedia.org/wiki/McLaren",
                                                    "name": "McLaren",
                                                    "nationality": "British"
                                                }
                                            ]
                                        },
                                        {
                                            "position": "2",
                                            "positionText": "2",
                                            "points": "226",
                                            "wins": "4",
                                            "Driver": {
                                                "driverId": "norris",
                                                "permanentNumber": "4",
                                                "code": "NOR",
                                                "url": "http://en.wikipedia.org/wiki/Lando_Norris",
                                                "givenName": "Lando",
                                                "familyName": "Norris",
                                                "dateOfBirth": "1999-11-13",
                                                "nationality": "British"
                                            },
                                            "Constructors": [
                                                {
                                                    "constructorId": "mclaren",
                                                    "url": "http://en.wikipedia.org/wiki/McLaren",
                                                    "name": "McLaren",
                                                    "nationality": "British"
                                                }
                                            ]
                                        },
                                        {
                                            "position": "3",
                                            "positionText": "3",
                                            "points": "165",
                                            "wins": "2",
                                            "Driver": {
                                                "driverId": "max_verstappen",
                                                "permanentNumber": "33",
                                                "code": "VER",
                                                "url": "http://en.wikipedia.org/wiki/Max_Verstappen",
                                                "givenName": "Max",
                                                "familyName": "Verstappen",
                                                "dateOfBirth": "1997-09-30",
                                                "nationality": "Dutch"
                                            },
                                            "Constructors": [
                                                {
                                                    "constructorId": "red_bull",
                                                    "url": "http://en.wikipedia.org/wiki/Red_Bull_Racing",
                                                    "name": "Red Bull",
                                                    "nationality": "Austrian"
                                                }
                                            ]
                                        },
                                        {
                                            "position": "4",
                                            "positionText": "4",
                                            "points": "147",
                                            "wins": "1",
                                            "Driver": {
                                                "driverId": "russell",
                                                "permanentNumber": "63",
                                                "code": "RUS",
                                                "url": "http://en.wikipedia.org/wiki/George_Russell_(racing_driver)",
                                                "givenName": "George",
                                                "familyName": "Russell",
                                                "dateOfBirth": "1998-02-15",
                                                "nationality": "British"
                                            },
                                            "Constructors": [
                                                {
                                                    "constructorId": "mercedes",
                                                    "url": "http://en.wikipedia.org/wiki/Mercedes-Benz_in_Formula_One",
                                                    "name": "Mercedes",
                                                    "nationality": "German"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    }
                }
                """.utf8
                )
        }
    }
}

