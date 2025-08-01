//
//  DriverModel.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import BaseDomain

public struct DriverModel {
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
    
    
    /// 각 Feature마다 사용하는 model이 다를 경우 삭제 후 각 Feature에서 관리
    public init(driver: Driver) {
        self.driverId = driver.driverId
        self.driverNumber = driver.driverNumber
        self.driverCode = driver.driverCode
        self.wikipediaURL = driver.wikipediaURL
        self.fullName = driver.fullName
        self.givenName = driver.givenName
        self.familyName = driver.familyName
        self.dateOfBirth = driver.dateOfBirth
        self.countryCode = driver.countryCode
        self.country = driver.country
        self.headshotImageURL = driver.headshotImageURL
        self.teamName = driver.teamName
        self.teamColour = driver.teamColour
        self.standingPosition = driver.standingPosition
        self.standingPoints = driver.standingPoints
        self.wins = driver.wins
    }
    
    public init(
        driverId: String,
        driverNumber: String?,
        driverCode: String?,
        wikipediaURL: String?,
        fullName: String,
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
        self.fullName = fullName
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
