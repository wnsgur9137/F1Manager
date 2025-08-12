//
//  Race.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

public struct Race {
    let season: String
    let round: String
    let url: String?
    let raceName: String
    let circuit: Circuit
    let date: String
    let time: String?
    let firstPractice: RaceDate?
    let secondPractice: RaceDate?
    let thirdPractice: RaceDate?
    let qualifying: RaceDate?
    let sprint: RaceDate?
    let sprintQualifying: RaceDate?
    let sprintShootout: RaceDate?
    
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
    let circuitId: String
    let url: String?
    let circuitName: String
    let location: CircuitLocation?
    let date: String?
    
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
    let lat: String
    let long: String
    let locality: String
    let country: String
    
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
    let date: String?
    let time: String?
    
    public init(
        date: String?,
        time: String?
    ) {
        self.date = date
        self.time = time
    }
}
