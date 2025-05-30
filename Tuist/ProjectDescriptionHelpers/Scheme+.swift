//
//  Scheme+.swift
//  F1manager
//
//  Created by JUNHYEOK LEE on 5/31/25.
//

import Foundation
import ProjectDescription

extension Scheme {
    static func makeScheme(
        target: AppConfiguration,
        name: String
    ) -> Self {
        return Scheme.scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target.configurationName,
                options: .options(coverage: true)
            ),
            runAction: .runAction(configuration: target.configurationName),
            archiveAction: .archiveAction(configuration: target.configurationName),
            profileAction: .profileAction(configuration: target.configurationName),
            analyzeAction: .analyzeAction(configuration: target.configurationName)
        )
    }
    
    static func makeDemoScheme(
        target: AppConfiguration,
        name: String
    ) -> Self {
        return Scheme.scheme(
            name: "\(name)DemoApp",
            shared: true,
            buildAction: .buildAction(targets: ["\(name)DemoApp"]),
            testAction: .targets(
                ["\(name)Tests"],
                arguments: nil,
                configuration: target.configurationName,
                options: .options(coverage: true)
            ),
            runAction: .runAction(configuration: target.configurationName),
            archiveAction: .archiveAction(configuration: target.configurationName),
            profileAction: .profileAction(configuration: target.configurationName),
            analyzeAction: .analyzeAction(configuration: target.configurationName)
        )
    }
}
