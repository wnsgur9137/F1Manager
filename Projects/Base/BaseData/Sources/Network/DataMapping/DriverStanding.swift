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
    
    private enum RootKeys: String, CodingKey {
        case MRData
    }
    
    private enum MRDataKeys: String, CodingKey {
        case StandingsTable
    }
    
    private enum StandingsTableKeys: String, CodingKey {
        case StandingsLists
    }
    
    private enum StandingsListKeys: String, CodingKey {
        case DriverStandings
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let mrData = try container.nestedContainer(keyedBy: MRDataKeys.self, forKey: .MRData)
        let standingsTable = try mrData.nestedContainer(keyedBy: StandingsTableKeys.self, forKey: .StandingsTable)
        let standingsListsArray = try standingsTable.decode([StandingsList].self, forKey: .StandingsLists)
        
        // StandingsLists 배열의 첫 번째 요소에서 DriverStandings 추출
        if let firstStandingsList = standingsListsArray.first {
            self.driverStandings = firstStandingsList.driverStandings
        } else {
            self.driverStandings = []
        }
    }
}

private struct StandingsList: Decodable {
    let driverStandings: [DriverStandingResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case driverStandings = "DriverStandings"
    }
}
