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
    name: "Onboarding",
    product: .framework,
    dependencies: [
        .Project.Feature.Data.OnboardingData,
        .Project.Feature.Domain.OnboardingDomain,
        .Project.Feature.Presentation.OnboardingPresentation
    ]
)
