//
//  PositionResponseDTO.swift
//  BaseData
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

struct PositionResponseDTO: Decodable {
    let date: String
    let driverNumber: Int
    let meetingKey: Int
    let position: Int
    let sessionKey: Int
    let x: Double
    let y: Double
    let z: Double
    
    enum CodingKeys: String, CodingKey {
        case date
        case driverNumber = "driver_number"
        case meetingKey = "meeting_key"
        case position
        case sessionKey = "session_key"
        case x
        case y
        case z
    }
}

// MARK: - Computed Properties
extension PositionResponseDTO {
    /// 2D 좌표점 (미니맵 표시용)
    var coordinate: CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    /// 날짜 포맷 변환
    var formattedDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: date)
    }
}
