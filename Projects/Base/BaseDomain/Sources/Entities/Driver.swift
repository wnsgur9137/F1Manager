//
//  Driver.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 7/16/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

public struct Driver {
    public let driverId: String
    public let driverNumber: String?
    public let driverCode: String?
    public let wikipediaURL: String?
    public let fullName: String
    public let givenName: String
    public let familyName: String
    public let dateOfBirth: String?
    public let countryCode: String?
    public let country: String?
    public let headshotImageURL: String?
    public let teamName: String?
    public let teamColour: String?
    public let standingPosition: Int?
    public let standingPoints: Int?
    public let wins: Int?
    
    public init(
        driverId: String,
        driverNumber: String?,
        driverCode: String?,
        wikipediaURL: String?,
        givenName: String,
        familyName: String,
        dateOfBirth: String?,
        countryCode: String?,
        country: String?,
        headshotImageURL: String?,
        teamName: String?,
        teamColour: String?,
        standingPosition: Int?,
        standingPoints: Int?,
        wins: Int?
    ) {
        self.driverId = driverId
        self.driverNumber = driverNumber
        self.driverCode = driverCode
        self.wikipediaURL = wikipediaURL
        self.fullName = "\(givenName) \(familyName)"
        self.givenName = givenName
        self.familyName = familyName
        self.dateOfBirth = dateOfBirth
        self.countryCode = countryCode
        self.country = country
        self.headshotImageURL = headshotImageURL
        self.teamName = teamName
        self.teamColour = teamColour
        self.standingPosition = standingPosition
        self.standingPoints = standingPoints
        self.wins = wins
    }
}
