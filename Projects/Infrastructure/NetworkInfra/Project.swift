//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 6/2/25.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "NetworkInfra",
    product: .framework,
    dependencies: [
        .Project.LibraryManager.ReactiveLibraries,
        .Project.LibraryManager.NetworkLibraries
    ]
)
