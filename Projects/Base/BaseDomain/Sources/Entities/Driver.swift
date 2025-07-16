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
    public let permanentNumber: String?
    public let driverCode: String?
    public let wikipediaURL: String?
    public let givenName: String
    public let familyName: String
    public let dateOfBirth: String?
    public let nationality: String?
    
    public init(
        driverId: String,
        permanentNumber: String?,
        driverCode: String?,
        wikipediaURL: String?,
        givenName: String,
        familyName: String,
        dateOfBirth: String?,
        nationality: String?
    ) {
        self.driverId = driverId
        self.permanentNumber = permanentNumber
        self.driverCode = driverCode
        self.wikipediaURL = wikipediaURL
        self.givenName = givenName
        self.familyName = familyName
        self.dateOfBirth = dateOfBirth
        self.nationality = nationality
    }
}
