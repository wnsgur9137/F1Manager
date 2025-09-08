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
    name: "SettingsData",
    product: .staticFramework,
    dependencies: [
        .Project.Base.Data,
        .Project.Feature.Domain.SettingsDomain,
    ]
)
