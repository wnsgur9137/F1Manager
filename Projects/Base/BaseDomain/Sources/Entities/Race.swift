//
//  Race.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

public struct Race {
    public let season: String
    public let round: String
    public let url: String?
    public let raceName: String
    public let circuit: Circuit
    public let date: String
    public let time: String?
    public let firstPractice: RaceDate?
    public let secondPractice: RaceDate?
    public let thirdPractice: RaceDate?
    public let qualifying: RaceDate?
    public let sprint: RaceDate?
    public let sprintQualifying: RaceDate?
    public let sprintShootout: RaceDate?
    
    public init(
        season: String,
        round: String,
        url: String?,
        raceName: String,
        circuit: Circuit,
        date: String,
        time: String?,
        firstPractice: RaceDate?,
        secondPractice: RaceDate?,
        thirdPractice: RaceDate?,
        qualifying: RaceDate?,
        sprint: RaceDate?,
        sprintQualifying: RaceDate?,
        sprintShootout: RaceDate?
    ) {
        self.season = season
        self.round = round
        self.url = url
        self.raceName = raceName
        self.circuit = circuit
        self.date = date
        self.time = time
        self.firstPractice = firstPractice
        self.secondPractice = secondPractice
        self.thirdPractice = thirdPractice
        self.qualifying = qualifying
        self.sprint = sprint
        self.sprintQualifying = sprintQualifying
        self.sprintShootout = sprintShootout
    }
}

public struct Circuit {
    public let circuitId: String
    public let url: String?
    public let circuitName: String
    public let location: CircuitLocation?
    public let date: String?
    
    public init(
        circuitId: String,
        url: String?,
        circuitName: String,
        location: CircuitLocation?,
        date: String?
    ) {
        self.circuitId = circuitId
        self.url = url
        self.circuitName = circuitName
        self.location = location
        self.date = date
    }
}

public struct CircuitLocation {
    public let lat: String
    public let long: String
    public let locality: String
    public let country: String
    
    public init(
        lat: String,
        long: String,
        locality: String,
        country: String
    ) {
        self.lat = lat
        self.long = long
        self.locality = locality
        self.country = country
    }
}

public struct RaceDate {
    public let date: String?
    public let time: String?
    
    public init(
        date: String?,
        time: String?
    ) {
        self.date = date
        self.time = time
    }
}
