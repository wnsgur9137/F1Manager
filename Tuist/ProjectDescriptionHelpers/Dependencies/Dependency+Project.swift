//
//  Dependency+Project.swift
//  F1manager
//
//  Created by JUNHYEOK LEE on 5/31/25.
//

import Foundation
import ProjectDescription

public enum ProjectLayer: String {
    case Application
    case InjectionManager
    case Infrastructure
    case Feature
    case Data
    case Domain
    case Presentation
    case LibraryManager
}

public enum ProjectDomain {
    case Splash
    case Onboarding
    case Home
}

// MARK: - Projects
extension TargetDependency {
    public struct Project {
        public struct InjectionManager { }
        public struct Infrastructure { }
        public struct Feature {
            public struct Data { }
            public struct Domian { }
            public struct Presentation { }
        }
        public struct LibraryManager { }
    }
}

// MARK: - InjectionManager
public extension TargetDependency.Project.InjectionManager {
    static let InjectionManager: TargetDependency = .project(name: "InjectionManager")
}

// MARK: - Infrastructure
public extension TargetDependency.Project.Infrastructure {
    
}

// MARK: - Feature
public extension TargetDependency.Project.Feature {
    static let Features: TargetDependency = .project(
        layer: .Feature,
        name: "Features"
    ),
    static let Splash: TargetDependency = .project(
        to: .Feature,
        domain: .Splash,
        name: "Splash"
    )
    static let Onboarding: TargetDependency = .project(
        to: .Feature,
        domain: .Onboarding,
        name: "Onboarding"
    )
    static let Home: TargetDependency = .project(
        to: .Feature,
        domain: .Home,
        name: "Home"
    )
}

// MARK: - Data
public extension TargetDependency.Project.Feature.Data {
    static let SplashData: TargetDependency = .project(
        to: .Feature,
        domain: .Splash,
        name: "SplashData"
    )
    static let OnboardingData: TargetDependency = .project(
        to: .Feature,
        domain: .Onboarding,
        name: "OnboardingData"
    )
    static let HomeData: TargetDependency = .project(
        to: .Feature,
        domain: .Home,
        name: "HomeData"
    )
}

// MARK: - Domain
public extension TargetDependency.Project.Feature.Domian {
    static let SplashDomain: TargetDependency = .project(
        to: .Feature,
        domain: .Splash,
        name: "SplashDomain"
    )
    static let OnboardingDomain: TargetDependency = .project(
        to: .Feature,
        domain: .Onboarding,
        name: "OnboardingDomain"
    )
    static let HomeDomain: TargetDependency = .project(
        to: .Feature,
        domain: .Home,
        name: "HomeDomain"
    )
}

// MARK: - Presentation
public extension TargetDependency.Project.Feature.Presentation {
    static let SplashPresentation: TargetDependency = .project(
        to: .Feature,
        domain: .Splash,
        name: "SplashPresentation"
    )
    static let OnboardingPresentation: TargetDependency = .project(
        to: .Feature,
        domain: .Onboarding,
        name: "OnboardingPresentation"
    )
    static let HomePresentation: TargetDependency = .project(
        to: .Feature,
        domain: .Home,
        name: "HomePresentation"
    )
}

// MARK: - LibraryManager
public extension TargetDependency.Project.LibraryManager {
    
}

// MARK: - TragetDependency
public extension TargetDependency {
    static func project(
        layer: ProjectLayer
    ) -> Self {
        return .project(
            target: layer.rawValue,
            path: .relative(to: layer)
        )
    }
    
    static func project(
        layer: ProjectLayer,
        name: String
    ) -> Self {
        return .project(
            target: name,
            path: .relative(
                to: layer,
                name: name
            )
        )
    }
    
    static func project(
        name: String
    ) -> Self {
        return .project(
            target: name,
            path: .relativeToProject(name: name)
        )
    }
}
