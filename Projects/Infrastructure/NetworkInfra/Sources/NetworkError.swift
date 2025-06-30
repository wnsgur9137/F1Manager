//
//  NetworkError.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 6/30/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

enum TokenError: Error {
    case tokenError
}

enum NetworkError: Error {
    case empty
    case requestTimeOut(Error)
    case internetConnection(Error)
    case rest(
        Error,
        statusCode: Int? = nil,
        errorCode: String? = nil,
        message: String? = nil
    )
    
    var statusCode: Int? {
        switch self {
        case let .rest(_, statusCode, _, _):
            return statusCode
        default:
            return nil
        }
    }
    
    var errorCode: [String] {
        switch self {
        case let .rest(_, _, errorCode, _):
            return [errorCode].compactMap { $0 }
        default:
            return []
        }
    }
    
    var isNotConnection: Bool {
        switch self {
        case let .requestTimeOut(error):
            fallthrough
        case let .rest(error, _, _, _):
            return UserTargetType.isNotConnection(error: error) || UserTargetType.isLostConnection(error: error)
        case .internetConnection:
            return true
        case .empty:
            return false
        }
    }
}

protocol MoyaErrorHandleable: TargetType {
    func internetConnection<T: Any>(error: Error) throws -> Single<T>
    func timeOut<T: Any>(error: Error) throws -> Single<T>
    func tokenError<T: Any>(error: Error) throws -> Single<T>
    func rest<T: Any>(error: Error) throws -> Single<T>
}

extension MoyaErrorHandleable {
    func internetConnection<T: Any>(error: Error) throws -> Single<T> {
        guard let urlError = Self.converToURLError(error),
              Self.isNotConnection(error: error) else { throw error }
        throw NetworkError.internetConnection(urlError)
    }
    
    func timeOut<T: Any>(error: Error) throws -> Single<T> {
        guard let urlError = Self.converToURLError(error),
              urlError.code == .timedOut else { throw error }
        throw NetworkError.requestTimeOut(urlError)
    }
    
    func tokenError<T: Any>(error: Error) throws -> Single<T> {
        guard let moyaError = error as? MoyaError,
              let response = moyaError.response else { throw error }
        if response.statusCode == 401 {
            throw TokenError.tokenError
        }
        throw error
    }
    
    func rest<T: Any>(error: Error) throws -> Single<T> {
        if error is TokenError { throw error }
        guard error is NetworkError else {
            throw NetworkError.rest(
                error,
                statusCode: (error as? MoyaError)?.response?.statusCode,
                errorCode: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["code"] as? String,
                message: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["message"] as? String
            )
        }
        throw error
    }
}

extension TargetType {
    static func converToURLError(_ error: Error) -> URLError? {
        switch error {
        case let MoyaError.underlying(afError as AFError, _):
            fallthrough
        case let afError as AFError:
            return afError.underlyingError as? URLError
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            return urlError
        default:
            return nil
        }
    }
    
    static func isNotConnection(error: Error) -> Bool {
        Self.converToURLError(error)?.code == .notConnectedToInternet
    }
    
    static func isLostConnection(error: Error) -> Bool {
        switch error {
        case let AFError.sessionTaskFailed(error: posixError as POSIXError) where posixError.code == .ECONNABORTED:
            break
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            guard urlError.code == URLError.networkConnectionLost else { fallthrough }
            break
        default:
            return false
        }
        return true
    }
}
