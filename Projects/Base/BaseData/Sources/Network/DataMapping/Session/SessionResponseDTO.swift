//
//  SessionResponseDTO.swift
//  BaseData
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

struct SessionResponseDTO: Decodable {
    let circuitKey: Int
    let circuitShortName: String
    let countryCode: String
    let countryKey: Int
    let countryName: String
    let dateEnd: String
    let dateStart: String
    let gmtOffset: String
    let location: String
    let meetingKey: Int
    let sessionKey: Int
    let sessionName: String
    let sessionType: String
    let year: Int
    
    enum CodingKeys: String, CodingKey {
        case circuitKey = "circuit_key"
        case circuitShortName = "circuit_short_name"
        case countryCode = "country_code"
        case countryKey = "country_key"
        case countryName = "country_name"
        case dateEnd = "date_end"
        case dateStart = "date_start"
        case gmtOffset = "gmt_offset"
        case location
        case meetingKey = "meeting_key"
        case sessionKey = "session_key"
        case sessionName = "session_name"
        case sessionType = "session_type"
        case year
    }
}

extension SessionResponseDTO {
    /// 세션 시작 날짜
    var startDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateStart)
    }
    
    /// 세션 종료 날짜
    var endDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateEnd)
    }
    
    /// 국가 플래그 이모지
    var countryFlag: String {
        return countryCode.flag
    }
    
    /// 세션 지속 시간
    var duration: TimeInterval? {
        guard let start = startDate, let end = endDate else { return nil }
        return end.timeIntervalSince(start)
    }
}
