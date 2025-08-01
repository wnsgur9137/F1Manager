//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 5/31/25.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "HomePresentation",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Domain.HomeDomain,
        .Project.Base.Presentation
    ]
)
