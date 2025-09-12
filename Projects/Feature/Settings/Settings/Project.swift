//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 9/8/25.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "Settings",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.SettingsData,
        .Project.Feature.Domain.SettingsDomain,
        .Project.Feature.Presentation.SettingsPresentation
    ]
)
