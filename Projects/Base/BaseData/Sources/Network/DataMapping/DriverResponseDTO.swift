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
    func toDomain(
        driverDetail: DriverDetailResponseDTO?,
        driverStanding: DriverStandingResponseDTO?
    ) -> Driver {
        let standingPosition: Int?
        let standingPoints: Int?
        let wins: Int?
        if let driverStanding = driverStanding {
            standingPosition = Int(driverStanding.position)
            standingPoints = Int(driverStanding.points)
            wins = Int(driverStanding.wins)
        } else {
            standingPosition = nil
            standingPoints = nil
            wins = nil
        }
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
            teamColour: driverDetail?.teamColour,
            standingPosition: standingPosition,
            standingPoints: standingPoints,
            wins: wins
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
    
    enum CodingKeys: String, CodingKey {
        case MRData
        case DriverTable
        case Drivers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mrData = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .MRData)
        let driverTable = try mrData.nestedContainer(keyedBy: CodingKeys.self, forKey: .DriverTable)
        self.drivers = try driverTable.decode([DriverResponseDTO].self, forKey: .Drivers)
    }
}
