//
//  ApplicationTargetType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 6/30/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import Moya

public enum ApplicationTargetType {
    
}

extension ApplicationTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "")!
    }
    
    public var path: String {
        switch self {
        
        }
    }
    
    public var method: Moya.Method {
        switch self {
            
        }
    }
    
    public var headers: [String : String]? {
        switch self {
            
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
            
        }
    }
    
    public var task: Moya.Task {
        if method == .get {
            let encoding: URLEncoding = .queryString
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: encoding)
            }
        }
        let encoding: JSONEncoding = .default
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
        return .requestPlain
    }
}

extension ApplicationTargetType {
    public var sampleData: Data {
        switch self {
            
        }
    }
}
