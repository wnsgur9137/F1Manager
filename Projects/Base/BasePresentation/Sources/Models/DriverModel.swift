//
//  DriverDetailModel.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

public struct DriverDetailModel {
    public let broadcastName: String
    public let countryCode: String?
    public let driverNumber: Int
    public let fullName: String
    public let firstName: String
    public let lastName: String
    public let headshotImageURL: String
    public let nameAcronym: String
    public let meetingKey: Int
    public let sessionKey: Int
    public let teamName: String
    public let teamColour: String
    
    public init(
        broadcastName: String,
        countryCode: String?,
        driverNumber: Int,
        fullName: String,
        firstName: String,
        lastName: String,
        headshotImageURL: String,
        nameAcronym: String,
        meetingKey: Int,
        sessionKey: Int,
        teamName: String,
        teamColour: String
    ) {
        self.broadcastName = broadcastName
        self.countryCode = countryCode
        self.driverNumber = driverNumber
        self.fullName = fullName
        self.firstName = firstName
        self.lastName = lastName
        self.headshotImageURL = headshotImageURL
        self.nameAcronym = nameAcronym
        self.meetingKey = meetingKey
        self.sessionKey = sessionKey
        self.teamName = teamName
        self.teamColour = teamColour
    }
}
