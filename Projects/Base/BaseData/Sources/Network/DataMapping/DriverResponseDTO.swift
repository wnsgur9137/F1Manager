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
    let driverNumber: String?
    let driverCode: String?
    let wikipediaURL: String?
    let givenName: String
    let familyName: String
    let dateOfBirth: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case driverId
        case driverNumber = "permanentNumber"
        case driverCode = "code"
        case wikipediaURL = "url"
        case givenName
        case familyName
        case dateOfBirth
        case country = "nationality"
    }
}

extension DriverResponseDTO {
    func toDomain(driverDetail: DriverDetailResponseDTO?) -> Driver {
        return Driver(
            driverId: driverId,
            driverNumber: driverNumber,
            driverCode: driverCode,
            wikipediaURL: wikipediaURL,
            givenName: givenName,
            familyName: familyName,
            dateOfBirth: dateOfBirth,
            countryCode: driverDetail?.countryCode,
            country: country,
            headshotImageURL: driverDetail?.headshotImageURL,
            teamName: driverDetail?.teamName,
            teamColour: driverDetail?.teamColour
        )
    }
}

private struct DriverTableContainer: Decodable {
    struct DriverTable: Decodable {
        let Drivers: [DriverResponseDTO]
    }
    let DriverTable: DriverTable
}

struct DriversResponseDTO: Decodable {
    let drivers: [DriverResponseDTO]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mrData = try container.nestedContainer(keyedBy: CodingKeys.MRDataKeys.self, forKey: .MRData)
        let driverTable = try mrData.decode(DriverTableContainer.self, forKey: .DriverTable)
        self.drivers = driverTable.DriverTable.Drivers
    }
    
    enum CodingKeys: String, CodingKey {
        case MRData
        enum MRDataKeys: String, CodingKey {
            case DriverTable
        }
    }
}
