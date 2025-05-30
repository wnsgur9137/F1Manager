//
//  Path+XCConfig.swift
//  F1manager
//
//  Created by JUNHYEOK LEE on 5/31/25.
//

import Foundation

extension Path {
    public struct XCConfig {
        public static func app(_ configuration: AppConfiguration) -> Path {
            return "//XCConfig/Application/Application-\(configuration.rawValue).xcconfig"
        }
        
        public static func xcconfig(_ configuration: AppConfiguration) -> Path {
            return "//XCConfig/\(configuration.rawValue).xcconfig"
        }
    }
}
