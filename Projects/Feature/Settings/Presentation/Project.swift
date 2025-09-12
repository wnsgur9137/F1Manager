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
    name: "SettingsPresentation",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Domain.SettingsDomain,
        .Project.Base.Presentation,
        .Project.LibraryManager.ReactiveLibraries
    ]
)
