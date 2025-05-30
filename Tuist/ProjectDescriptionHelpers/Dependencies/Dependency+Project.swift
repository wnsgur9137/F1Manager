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
    )
}

// MARK: - Data
public extension TargetDependency.Project.Feature.Data {
    
}

// MARK: - Domain
public extension TargetDependency.Project.Feature.Domian {
    
}

// MARK: - Presentation
public extension TargetDependency.Project.Feature.Presentation {
    
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
