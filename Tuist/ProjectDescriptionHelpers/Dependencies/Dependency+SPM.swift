//
//  Dependency+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 6/2/25.
//

import Foundation
import ProjectDescription

// MARK: - Group
extension TargetDependency {
    public struct SPM {
        public struct Network { }
        public struct Data { }
        public struct Kakao { }
        public struct Layout { }
        public struct Reactive { }
        public struct UI { }
        public struct Test { }
    }
}

extension Package {
    public struct UI { }
    public struct Test { }
}

// MARK: - Network
public extension TargetDependency.SPM.Network {
    static let Alamofire: TargetDependency = .external(name: "Alamofire")
    static let Moya: TargetDependency = .external(name: "RxMoya")
}

// MARK: - Layout
public extension TargetDependency.SPM.Layout {
    static let snapKit: TargetDependency = .external(name: "SnapKit")
}

// MARK: - Reactive
public extension TargetDependency.SPM.Reactive {
    static let RxSwift: TargetDependency = .external(name: "RxSwift")
    static let RxCocoa: TargetDependency = .external(name: "RxCocoa")
    static let RxGesture: TargetDependency = .external(name: "RxGesture")
    static let ReactorKit: TargetDependency = .external(name: "ReactorKit")
}

// MARK: - UI
public extension TargetDependency.SPM.UI {
    static let SkeletonView: TargetDependency = .external(name: "SkeletonView")
    static let KingFisher: TargetDependency = .external(name: "Kingfisher")
    static let DropDown: TargetDependency = .external(name: "DropDown")
    static let Lottie: TargetDependency = .external(name: "Lottie")
    static let IQKeyboardManager: TargetDependency = .external(name: "IQKeyboardManagerSwift")
    static let AcknowList: TargetDependency = .external(name: "AcknowList")
}

// MARK: - Test
public extension TargetDependency.SPM.Test {
    static let RxBlocking: TargetDependency = .external(name: "RxBlocking")
    static let RxTest: TargetDependency = .external(name: "RxTest")
    static let RxNimble: TargetDependency = .external(name: "RxNimble")
}
