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
        .Project.Base.Domain,
        .Project.LibraryManager.ReactiveLibraries,
        .Project.LibraryManager.LayoutLibraries,
        .Project.LibraryManager.UILibraries,
    ],
    hasResource: true
)
