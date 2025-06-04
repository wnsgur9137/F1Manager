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
    name: "BasePresentation",
    product: .staticFramework,
    dependencies: [
        .Project.LibraryManager.ReactiveLibraries,
        .Project.LibraryManager.LayoutLibraries,
        .Project.LibraryManager.UILibraries,
    ]
)
