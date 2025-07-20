//
//  CarDataResponseDTO.swift
//  BaseData
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

struct CarDataResponseDTO: Decodable {
    let brake: Int
    let date: String
    let driverNumber: Int
    let drs: Int
    let gear: Int
    let meetingKey: Int
    let rpm: Int
    let sessionKey: Int
    let speed: Int
    let throttle: Int
    
    enum CodingKeys: String, CodingKey {
        case brake
        case date
        case driverNumber = "driver_number"
        case drs
        case gear
        case meetingKey = "meeting_key"
        case rpm
        case sessionKey = "session_key"
        case speed
        case throttle
    }
}

extension CarDataResponseDTO {
    /// DRS 활성화 여부
    var isDrsActive: Bool {
        return drs == 1
    }
    
    /// 브레이크 사용률 (0.0 ~ 1.0)
    var brakePercentage: Double {
        return Double(brake) / 100.0
    }
    
    /// 스로틀 사용률 (0.0 ~ 1.0)
    var throttlePercentage: Double {
        return Double(throttle) / 100.0
    }
    
    /// 날짜 포맷 변환
    var formattedDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: date)
    }
}
