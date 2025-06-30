//
//  Logger.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 6/30/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

public func Log<T>(
    _ object: T?,
    filename: String = #file,
    line: Int = #line,
    functionName: String = #function
) {
    #if DEBUG
    let date = Date()
    let dateFormat = DateFormatter()
    dateFormat.calendar = .current
    dateFormat.dateFormat = "🛠️ 디버깅 로그 YYYY-MM-dd hh:mm:ss SSS"
    let formatDate = dateFormat.string(from: date)
    if let object = object {
        print("\(formatDate) \(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(functionName) : \(object)")
    } else {
        print("\(formatDate) \(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(functionName) : nil")
    }
    #endif
}
