//
//  RaceTargetType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import Moya

public enum RaceTargetType {
    case getRaces(year: Int)
    case getRound(year: Int, round: Int)
    case getRaceDriver(driverName: String)
    case getRaceConstructor(constructorName: String)
    case getRaceGrid(gridPosition: Int)
    case getRaceStatus(statusId: Int)
}

extension RaceTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "https://api.jolpi.ca/ergast/f1")!
    }
    
    public var path: String {
        switch self {
        case let .getRaces(year):
            return "/\(year)/races"
        case let .getRound(year, round):
            return "/\(year)/\(round)/races"
        case let .getRaceDriver(driverName):
            return "/drivers/\(driverName)/races"
        case let .getRaceConstructor(constructorName):
            return "/constructors/\(constructorName)/races"
        case let .getRaceGrid(gridPosition):
            return "/grid/\(gridPosition)/races"
        case let .getRaceStatus(statusId):
            return "/status/\(statusId)/races"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getRaces: return .get
        case .getRound: return .get
        case .getRaceDriver: return .get
        case .getRaceConstructor: return .get
        case .getRaceGrid: return .get
        case .getRaceStatus: return .get
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .getRaces:
            return nil
        case .getRound:
            return nil
        case .getRaceDriver:
            return nil
        case .getRaceConstructor:
            return nil
        case .getRaceGrid:
            return nil
        case .getRaceStatus:
            return nil
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getRaces:
            return nil
        case .getRound:
            return nil
        case .getRaceDriver:
            return nil
        case .getRaceConstructor:
            return nil
        case .getRaceGrid:
            return nil
        case .getRaceStatus:
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

extension RaceTargetType {
    public var sampleData: Data {
        return Data(
            """
            """.utf8
        )
    }
}
