//
//  DriverResponseDTO.swift
//  BaseData
//
//  Created by JunHyeok Lee on 7/16/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import BaseDomain

struct DriverResponseDTO: Decodable {
    let driverId: String
    let permanentNumber: String?
    let driverCode: String?
    let wikipediaURL: String?
    let givenName: String
    let familyName: String
    let dateOfBirth: String?
    let nationality: String?
    
    enum CodingKeys: String, CodingKey {
        case driverId
        case permanentNumber
        case driverCode = "code"
        case wikipediaURL = "url"
        case givenName
        case familyName
        case dateOfBirth
        case nationality
    }
}

extension DriverResponseDTO {
    func toDomain() -> Driver {
        return Driver(
            driverId: driverId,
            permanentNumber: permanentNumber,
            driverCode: driverCode,
            wikipediaURL: wikipediaURL,
            givenName: givenName,
            familyName: familyName,
            dateOfBirth: dateOfBirth,
            nationality: nationality
        )
    }
}
