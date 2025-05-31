//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 6/1/25.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "InjectionManager",
    product: .staticFramework,
    dependencies: [
//        .Project.Infrastructure.Network,
//        .Project.Infrastructure.Notification,
        .Project.Feature.Features
    ]
)
