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
    name: "Splash",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.SplashData,
        .Project.Feature.Domain.SplashDomain,
        .Project.Feature.Presentation.SplashPresentation
    ]
)
