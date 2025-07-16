//
//  DriverDetailResponseDTO.swift
//  BaseData
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

import BaseDomain

struct DriverDetailResponseDTO: Decodable {
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
    
    enum CodingKeys: String, CodingKey {
        case broadcastName = "broadcast_name"
        case countryCode = "country_code"
        case driverNumber = "driver_number"
        case fullName = "full_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case headshotImageURL = "headshot_url"
        case nameAcronym = "name_acronym"
        case meetingKey = "meeting_key"
        case sessionKey = "session_key"
        case teamName = "team_name"
        case teamColour = "team_colour"
    }
}

extension DriverDetailResponseDTO {
    func toDomain() -> DriverDetail {
        return DriverDetail(
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
