//
//  RaceResponseDTO.swift
//  BaseData
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import BaseDomain

// MARK: - RaceResponseDTO
struct RaceResponseDTO: Decodable {
    let season: String
    let round: String
    let url: String?
    let raceName: String
    let circuit: CircuitResponseDTO
    let date: String
    let time: String?
    let firstPractice: RaceDateResponseDTO?
    let secondPractice: RaceDateResponseDTO?
    let thirdPractice: RaceDateResponseDTO?
    let qualifying: RaceDateResponseDTO?
    let sprint: RaceDateResponseDTO?
    let sprintQualifying: RaceDateResponseDTO?
    let sprintShootout: RaceDateResponseDTO?
    
    enum CodingKeys: String, CodingKey {
        case season
        case round
        case url
        case raceName
        case circuit = "Circuit"
        case date
        case time
        case firstPractice = "FirstPractice"
        case secondPractice = "SecondPractice"
        case thirdPractice = "ThirdPractice"
        case qualifying = "Qualifying"
        case sprint = "Sprint"
        case sprintQualifying = "SprintQualifying"
        case sprintShootout = "SprintShootout"
    }
}

extension RaceResponseDTO {
    func toDomain() -> Race {
        return Race(
            season: self.season,
            round: self.round,
            url: self.url,
            raceName: self.raceName,
            circuit: self.circuit.toDomain(),
            date: self.date,
            time: self.time,
            firstPractice: self.firstPractice?.toDomain(),
            secondPractice: self.secondPractice?.toDomain(),
            thirdPractice: self.thirdPractice?.toDomain(),
            qualifying: self.qualifying?.toDomain(),
            sprint: self.sprint?.toDomain(),
            sprintQualifying: self.sprint?.toDomain(),
            sprintShootout: self.sprintShootout?.toDomain()
        )
    }
}

// MARK: - CircuitResponseDTO
struct CircuitResponseDTO: Decodable {
    let circuitId: String
    let url: String?
    let circuitName: String
    let location: CircuitLocationResponseDTO?
    let date: String?
}

extension CircuitResponseDTO {
    func toDomain() -> Circuit {
        return Circuit(
            circuitId: self.circuitId,
            url: self.url,
            circuitName: self.circuitName,
            location: self.location?.toDomain(),
            date: self.date
        )
    }
}

// MARK: - CircuitLocationResponseDTO
struct CircuitLocationResponseDTO: Decodable {
    let lat: String
    let long: String
    let locality: String
    let country: String
}

extension CircuitLocationResponseDTO {
    func toDomain() -> CircuitLocation {
        return CircuitLocation(
            lat: self.lat,
            long: self.long,
            locality: self.locality,
            country: self.country
        )
    }
}

// MARK: - RaceDateResponseDTO
struct RaceDateResponseDTO: Decodable {
    let date: String?
    let time: String?
}

extension RaceDateResponseDTO {
    func toDomain() -> RaceDate {
        return RaceDate(
            date: self.date,
            time: self.time
        )
    }
}

// MARK: - RaceTableContainer
private struct RaceTableContainer: Decodable {
    struct RaceTable: Decodable {
        let Races: [RaceResponseDTO]
    }
    let RaceTable: RaceTable
}

// MARK: - RacesResponseDTO
struct RacesResponseDTO: Decodable {
    let races: [RaceResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case MRData
        case RaceTable
        case Races
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mrData = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .MRData)
        let raceTable = try mrData.nestedContainer(keyedBy: CodingKeys.self, forKey: .RaceTable)
        self.races = try raceTable.decode([RaceResponseDTO].self, forKey: .Races)
    }
}
