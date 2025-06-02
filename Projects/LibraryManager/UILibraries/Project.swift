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
    name: "UILibraries",
    product: .framework,
    dependencies: [
        .SPM.UI.DropDown,
        .SPM.UI.KingFisher,
        .SPM.UI.SkeletonView,
        .SPM.UI.Lottie,
        .SPM.UI.IQKeyboardManager
    ]
)
