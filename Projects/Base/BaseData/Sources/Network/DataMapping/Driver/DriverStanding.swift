//
//  DriverStanding.swift
//  BaseData
//
//  Created by JunHyeok Lee on 7/18/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import BaseDomain

struct DriverStandingResponseDTO: Decodable {
    let position: String
    let points: String
    let wins: String
    let driver: DriverResponseDTO
//    let constructors: [ConstructorResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case position
        case points
        case wins
        case driver = "Driver"
//        case constructors = "Constructors"
    }
}


struct DriverStandingsTableResponseDTO: Decodable {
    let driverStandings: [DriverStandingResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
        case standingsTable = "StandingsTable"
        case standingsLists = "StandingsLists"
        case driverStandings = "DriverStandings"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mrData = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .mrData)
        let standingsTable = try mrData.nestedContainer(keyedBy: CodingKeys.self, forKey: .standingsTable)
        let standingsListsArray = try standingsTable.decode([StandingsList].self, forKey: .standingsLists)
        
        // StandingsLists 배열의 첫 번째 요소에서 DriverStandings 추출
        self.driverStandings = standingsListsArray.first?.driverStandings ?? []
    }
}

private struct StandingsList: Decodable {
    let driverStandings: [DriverStandingResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case driverStandings = "DriverStandings"
    }
}
