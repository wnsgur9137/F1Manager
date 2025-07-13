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
    name: "SplashData",
    product: .staticFramework,
    dependencies: [
        .Project.Base.Data,
        .Project.Feature.Domain.SplashDomain
    ]
)
