//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 6/4/25.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "BaseData",
    product: .staticFramework,
    dependencies: [
        .Project.LibraryManager.ReactiveLibraries,
        .Project.Infrastructure.Network
    ]
)
