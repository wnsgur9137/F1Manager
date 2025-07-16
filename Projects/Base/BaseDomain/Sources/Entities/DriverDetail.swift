//
//  Driver.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import BasePresentation

public struct DriverDetail {
    let broadcastName: String
    let countryCode: String?
    let driverNumber: Int
    let fullName: String
    let firstName: String
    let lastName: String
    let headshotImageURL: String
    let nameAcronym: String
    let meetingKey: Int
    let sessionKey: Int
    let teamName: String
    let teamColour: String
    
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

extension DriverDetail {
    func toModel() -> DriverDetailModel {
        return DriverDetailModel(
            broadcastName: broadcastName,
            countryCode: countryCode,
            driverNumber: driverNumber,
            fullName: fullName,
            firstName: firstName,
            lastName: lastName,
            headshotImageURL: headshotImageURL,
            nameAcronym: nameAcronym,
            meetingKey: meetingKey,
            sessionKey: sessionKey,
            teamName: teamName,
            teamColour: teamColour
        )
    }
}
