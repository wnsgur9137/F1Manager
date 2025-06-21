//
//  Project+Templates.swift
//  F1manager
//
//  Created by JUNHYEOK LEE on 5/31/25.
//

import Foundation
import ProjectDescription

let appVersion: Plist.Value = "0.0.1"
let bundleVersion: Plist.Value = "1"

public let defaultInfoPlist: [String: Plist.Value] = [
    "UILaunchStoryboardName": "LaunchScreen",
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
                [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                ]
            ]
        ]
    ],
    "CFBundleShortVersionString": appVersion,
    "CFBundleVersion": bundleVersion,
    "UIAppFonts": [
//        "SUITE-Bold.otf",
//        "SUITE-ExtraBold.otf",
//        "SUITE-Heavy.otf",
//        "SUITE-Light.otf",
//        "SUITE-Medium.otf",
//        "SUITE-Regular.otf",
//        "SUITE-SemiBold.otf"
    ],
    "AppConfigurations": [
//        "API_URL": "${API_URL}"
    ],
    "NSAppTransportSecurity": [
        "NSAllowsArbitraryLoads": true
    ],
    "LSApplicationQueriesSchemes": [
//        "kakaokompassauth",
//        "kakaolink"
    ],
    "CFBundleURLTypes": [
//        [
//            "CFBundleTypeRole": "Editor",
//            "CFBundleURLSchemes": [
//                "kakao\(String.kakaoNativeAppKey)",
//                "kakao\(String.devKakaoNativeAppKey)"
//            ]
//        ]
    ],
    "UISupportedInterfaceOrientations": [
        "UIInterfaceOrientationPortrait",
        "UIInterfaceOrientationPortraitUpsideDown",
        "UIInterfaceOrientationLandscapeLeft",
        "UIInterfaceOrientationLandscapeRight"
    ],
    "UISupportedInterfaceOrientations~ipad": [
        "UIInterfaceOrientationPortrait",
        "UIInterfaceOrientationPortraitUpsideDown",
        "UIInterfaceOrientationLandscapeLeft",
        "UIInterfaceOrientationLandscapeRight"
    ]
]

extension Project {
    public static func project(
        name: String,
        product: Product,
        destinations: Destinations = .iOS,
        organizationName: String = "com.junhyeok.F1Manager",
        settings: [String: SettingValue] = [:],
        packages: [Package] = [],
        deploymentTarget: DeploymentTargets? = .iOS("16.0"),
        dependencies: [TargetDependency] = [],
        infoPlist: [String: Plist.Value] = [:],
        hasTest: Bool = false,
        hasResource: Bool = false,
        hasDemoApp: Bool = false
    ) -> Project {
        let settings: Settings = .settings(
            base: [:
                // FlexLayout 사용 시 주석 해제
//                "OTHER_LDFLAGS": ["-lc++", "-Objc"],
//                "GCC_PREPROCESSOR_DEFINITIONS": ["FLEXLAYOUT_SWIFT_PACKAGE=1"]
            ],
            configurations: [
                .debug(name: .DEV),
                .debug(name: .TEST_DEV),
                .debug(name: .TEST_PROD),
                .release(name: .PROD)
            ],
            defaultSettings: .recommended
        )
        
        let target: Target = .target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTargets: deploymentTarget,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: hasResource ? ["Resources/**"] : nil,
            dependencies: dependencies,
            settings: .settings(base: ["ENABLE_TESTABILITY": "YES"])
        )
        
        let demoAppTarget: Target = .target(
            name: "\(name)DemoApp",
            destinations: destinations,
            product: .app,
            bundleId: "\(organizationName).\(name)DemoApp",
            deploymentTargets: deploymentTarget,
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["Demo/**"],
            resources: ["Demo/Resources/**"],
            dependencies: [.target(name: name)],
            settings: .settings(
                base: [
                    // FlexLayout 사용 시 주석 해제
//                    "OTHER_LDFLAGS": ["-lc++", "-Objc"],
                    "ENABLE_TESTABILITY": "YES"
                ],
                configurations: [
                    .debug(
                        name: .DEV,
                        xcconfig: .XCConfig.app(.DEV)
                    ),
                    .release(
                        name: .PROD,
                        xcconfig: .XCConfig.app(.PROD)
                    )
                ]
            )
        )
        
        let testTargetDependencies: [TargetDependency] = hasDemoApp ? [.target(name: "\(name)DemoApp")] : [.target(name: "\(name)")]
        
        let testTarget: Target = .target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            deploymentTargets: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: testTargetDependencies + [
//                .SPM.Test.RxTest,
//                .SPM.Test.RxBlocking,
//                .SPM.Test.RxNimble
            ]
        )
        
        let schemes: [Scheme] = hasDemoApp
        ? [
            .makeScheme(target: .DEV, name: name),
            .makeDemoScheme(target: .DEV, name: name)
        ]
        : [
            .makeScheme(target: .DEV, name: name)
        ]
        
        var targets: [Target] = [target]
        if hasTest {
            targets.append(testTarget)
        }
        if hasDemoApp {
            targets.append(demoAppTarget)
        }
        
        return Project(
            name: name,
            organizationName: organizationName,
            options: .options(
                defaultKnownRegions: ["en", "ko"],
                developmentRegion: "ko"
            ),
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
}
