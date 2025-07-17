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
    case getLatestDriverDetails
}

extension OpenF1DriverTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "https://api.openf1.org")!
    }
    
    public var path: String {
        switch self {
        case .getDriver: return "/v1/drivers"
        case .getLatestDriverDetails: return "/v1/drivers"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDriver: return .get
        case .getLatestDriverDetails: return .get
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getDriver:
            return nil
        case .getLatestDriverDetails:
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
        case .getLatestDriverDetails:
            return [
                "session_key": "latest"
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
        case .getLatestDriverDetails:
            return Data(
                """
                [
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 1,
                        "broadcast_name": "M VERSTAPPEN",
                        "full_name": "Max VERSTAPPEN",
                        "name_acronym": "VER",
                        "team_name": "Red Bull Racing",
                        "team_colour": "4781D7",
                        "first_name": "Max",
                        "last_name": "Verstappen",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 4,
                        "broadcast_name": "L NORRIS",
                        "full_name": "Lando NORRIS",
                        "name_acronym": "NOR",
                        "team_name": "McLaren",
                        "team_colour": "F47600",
                        "first_name": "Lando",
                        "last_name": "Norris",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/L/LANNOR01_Lando_Norris/lannor01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 5,
                        "broadcast_name": "G BORTOLETO",
                        "full_name": "Gabriel BORTOLETO",
                        "name_acronym": "BOR",
                        "team_name": "Kick Sauber",
                        "team_colour": "01C00E",
                        "first_name": "Gabriel",
                        "last_name": "Bortoleto",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/G/GABBOR01_Gabriel_Bortoleto/gabbor01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 6,
                        "broadcast_name": "I HADJAR",
                        "full_name": "Isack HADJAR",
                        "name_acronym": "HAD",
                        "team_name": "Racing Bulls",
                        "team_colour": "6C98FF",
                        "first_name": "Isack",
                        "last_name": "Hadjar",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/I/ISAHAD01_Isack_Hadjar/isahad01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 10,
                        "broadcast_name": "P GASLY",
                        "full_name": "Pierre GASLY",
                        "name_acronym": "GAS",
                        "team_name": "Alpine",
                        "team_colour": "00A1E8",
                        "first_name": "Pierre",
                        "last_name": "Gasly",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/P/PIEGAS01_Pierre_Gasly/piegas01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 12,
                        "broadcast_name": "K ANTONELLI",
                        "full_name": "Kimi ANTONELLI",
                        "name_acronym": "ANT",
                        "team_name": "Mercedes",
                        "team_colour": "00D7B6",
                        "first_name": "Kimi",
                        "last_name": "Antonelli",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/A/ANDANT01_Andrea%20Kimi_Antonelli/andant01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 14,
                        "broadcast_name": "F ALONSO",
                        "full_name": "Fernando ALONSO",
                        "name_acronym": "ALO",
                        "team_name": "Aston Martin",
                        "team_colour": "229971",
                        "first_name": "Fernando",
                        "last_name": "Alonso",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/F/FERALO01_Fernando_Alonso/feralo01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 16,
                        "broadcast_name": "C LECLERC",
                        "full_name": "Charles LECLERC",
                        "name_acronym": "LEC",
                        "team_name": "Ferrari",
                        "team_colour": "ED1131",
                        "first_name": "Charles",
                        "last_name": "Leclerc",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/C/CHALEC01_Charles_Leclerc/chalec01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 18,
                        "broadcast_name": "L STROLL",
                        "full_name": "Lance STROLL",
                        "name_acronym": "STR",
                        "team_name": "Aston Martin",
                        "team_colour": "229971",
                        "first_name": "Lance",
                        "last_name": "Stroll",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/L/LANSTR01_Lance_Stroll/lanstr01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 22,
                        "broadcast_name": "Y TSUNODA",
                        "full_name": "Yuki TSUNODA",
                        "name_acronym": "TSU",
                        "team_name": "Red Bull Racing",
                        "team_colour": "4781D7",
                        "first_name": "Yuki",
                        "last_name": "Tsunoda",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/Y/YUKTSU01_Yuki_Tsunoda/yuktsu01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 23,
                        "broadcast_name": "A ALBON",
                        "full_name": "Alexander ALBON",
                        "name_acronym": "ALB",
                        "team_name": "Williams",
                        "team_colour": "1868DB",
                        "first_name": "Alexander",
                        "last_name": "Albon",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/A/ALEALB01_Alexander_Albon/alealb01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 27,
                        "broadcast_name": "N HULKENBERG",
                        "full_name": "Nico HULKENBERG",
                        "name_acronym": "HUL",
                        "team_name": "Kick Sauber",
                        "team_colour": "01C00E",
                        "first_name": "Nico",
                        "last_name": "Hulkenberg",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/N/NICHUL01_Nico_Hulkenberg/nichul01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 30,
                        "broadcast_name": "L LAWSON",
                        "full_name": "Liam LAWSON",
                        "name_acronym": "LAW",
                        "team_name": "Racing Bulls",
                        "team_colour": "6C98FF",
                        "first_name": "Liam",
                        "last_name": "Lawson",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/L/LIALAW01_Liam_Lawson/lialaw01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 31,
                        "broadcast_name": "E OCON",
                        "full_name": "Esteban OCON",
                        "name_acronym": "OCO",
                        "team_name": "Haas F1 Team",
                        "team_colour": "9C9FA2",
                        "first_name": "Esteban",
                        "last_name": "Ocon",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/E/ESTOCO01_Esteban_Ocon/estoco01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 43,
                        "broadcast_name": "F COLAPINTO",
                        "full_name": "Franco COLAPINTO",
                        "name_acronym": "COL",
                        "team_name": "Alpine",
                        "team_colour": "00A1E8",
                        "first_name": "Franco",
                        "last_name": "Colapinto",
                        "headshot_url": null,
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 44,
                        "broadcast_name": "L HAMILTON",
                        "full_name": "Lewis HAMILTON",
                        "name_acronym": "HAM",
                        "team_name": "Ferrari",
                        "team_colour": "ED1131",
                        "first_name": "Lewis",
                        "last_name": "Hamilton",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/L/LEWHAM01_Lewis_Hamilton/lewham01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 55,
                        "broadcast_name": "C SAINZ",
                        "full_name": "Carlos SAINZ",
                        "name_acronym": "SAI",
                        "team_name": "Williams",
                        "team_colour": "1868DB",
                        "first_name": "Carlos",
                        "last_name": "Sainz",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 63,
                        "broadcast_name": "G RUSSELL",
                        "full_name": "George RUSSELL",
                        "name_acronym": "RUS",
                        "team_name": "Mercedes",
                        "team_colour": "00D7B6",
                        "first_name": "George",
                        "last_name": "Russell",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/G/GEORUS01_George_Russell/georus01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 81,
                        "broadcast_name": "O PIASTRI",
                        "full_name": "Oscar PIASTRI",
                        "name_acronym": "PIA",
                        "team_name": "McLaren",
                        "team_colour": "F47600",
                        "first_name": "Oscar",
                        "last_name": "Piastri",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/O/OSCPIA01_Oscar_Piastri/oscpia01.png.transform/1col/image.png",
                        "country_code": null
                    },
                    {
                        "meeting_key": 1277,
                        "session_key": 9947,
                        "driver_number": 87,
                        "broadcast_name": "O BEARMAN",
                        "full_name": "Oliver BEARMAN",
                        "name_acronym": "BEA",
                        "team_name": "Haas F1 Team",
                        "team_colour": "9C9FA2",
                        "first_name": "Oliver",
                        "last_name": "Bearman",
                        "headshot_url": "https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/O/OLIBEA01_Oliver_Bearman/olibea01.png.transform/1col/image.png",
                        "country_code": null
                    }
                ]
                """.utf8
            )
        }
    }
}
