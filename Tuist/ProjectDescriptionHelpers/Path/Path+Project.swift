//
//  Path+Project.swift
//  F1manager
//
//  Created by JUNHYEOK LEE on 5/31/25.
//

import Foundation
import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToProject(
        name: String
    ) -> Self {
        return .relativeToRoot("Projects/\(name)")
    }
    
    static func relative(
        to layer: ProjectLayer
    ) -> Self {
        return .relativeToRoot("Projects/\(layer.rawValue)/\(layer.rawValue)")
    }
    
    static func relative(
        to layer: ProjectLayer,
        name: String
    ) -> Self {
        return .relativeToRoot("Projects/\(layer.rawValue)/\(name)")
    }
    
    static func relative(
        to layer: ProjectLayer,
        domain: ProjectDomain,
        name: String
    ) -> Self {
        return .relativeToRoot("Projects/\(layer.rawValue)/\(domain.rawValue)/\(name)")
    }
    
    static func relative(
        domain: ProjectDomain,
        layer: ProjectLayer
//        name: String
    ) -> Self {
        return .relativeToRoot("Projects/\(ProjectLayer.Feature.rawValue)/\(domain.rawValue)/\(layer.rawValue)")
    }
}
