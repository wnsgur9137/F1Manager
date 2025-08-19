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
    name: "ReactiveLibraries",
    product: .framework,
    dependencies: [
        .SPM.Reactive.ReactorKit,
        .SPM.Reactive.RxSwift,
        .SPM.Reactive.RxCocoa,
        .SPM.Reactive.RxDataSources,
        .SPM.Reactive.RxGesture
    ]
)
