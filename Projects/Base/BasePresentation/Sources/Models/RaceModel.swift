//
//  RaceModel.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import BaseDomain

public struct RaceModel {
    public let season: String
    public let round: String
    public let url: String?
    public let raceName: String
    public let circuit: CircuitModel
    public let date: String
    public let time: String?
    public let firstPractice: RaceDateModel?
    public let secondPractice: RaceDateModel?
    public let thirdPractice: RaceDateModel?
    public let qualifying: RaceDateModel?
    public let sprint: RaceDateModel?
    public let sprintQualifying: RaceDateModel?
    public let sprintShootout: RaceDateModel?
    
    public init(race: Race) {
        self.season = race.season
        self.round = race.round
        self.url = race.url
        self.raceName = race.raceName
        self.circuit = CircuitModel(circuit: race.circuit)
        self.date = race.date
        self.time = race.time
        self.firstPractice = race.firstPractice.map { RaceDateModel(raceDate: $0) }
        self.secondPractice = race.secondPractice.map { RaceDateModel(raceDate: $0) }
        self.thirdPractice = race.thirdPractice.map { RaceDateModel(raceDate: $0) }
        self.qualifying = race.qualifying.map { RaceDateModel(raceDate: $0) }
        self.sprint = race.sprint.map { RaceDateModel(raceDate: $0) }
        self.sprintQualifying = race.sprintQualifying.map { RaceDateModel(raceDate: $0) }
        self.sprintShootout = race.sprintShootout.map { RaceDateModel(raceDate: $0) }
    }
}

public struct CircuitModel {
    public let circuitId: String
    public let url: String?
    public let circuitName: String
    public let location: CircuitLocationModel?
    public let date: String?
    
    public init(circuit: Circuit) {
        self.circuitId = circuit.circuitId
        self.url = circuit.url
        self.circuitName = circuit.circuitName
        self.location = circuit.location.map { CircuitLocationModel(location: $0) }
        self.date = circuit.date
    }
}

public struct CircuitLocationModel {
    public let lat: String
    public let long: String
    public let locality: String
    public let country: String
    
    public init(location: CircuitLocation) {
        self.lat = location.lat
        self.long = location.long
        self.locality = location.locality
        self.country = location.country
    }
}

public struct RaceDateModel {
    public let date: String?
    public let time: String?
    
    public init(raceDate: RaceDate) {
        self.date = raceDate.date
        self.time = raceDate.time
    }
}
