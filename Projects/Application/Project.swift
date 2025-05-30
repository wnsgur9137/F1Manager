//
//  Project.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 5/31/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "F1Manager"
let organizationName = "com.junhyeok.F1Manager"
let deploymentTargets: DeploymentTargets = .iOS("16.0")

// MARK: - Settings
let settings: Settings = .settings(
    base: [
        "DEVELOPMENT_TEM": "VW2UR5Y845"
        // FlexLayout 사용 시 주석 해제
//        "GCC_PREPROCESSOR_DEFINITIONS": ["FLEXLAYOUT_SWIFT_PACKAGE=1"]
    ],
    configurations: [
        .debug(name: .DEV),
        .debug(name: .TEST_DEV),
        .debug(name: .TEST_PROD),
        .release(name: .PROD)
    ]
)

// MARK: - Scripts
let scripts: [TargetScript] = []

// MARK: - Target
let targets: [Target] = [
    .target(
        name: projectName,
        destinations: .iOS,
        product: .app,
        projectName: projectName,
        bundleId: organizationName,
        deploymentTargets: deploymentTargets,
        infoPlist: .extendingDefault(with: defaultInfoPlist),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        entitlements: "../../SupportingFiles/F1Manager.entitlements",
        scripts: scripts,
        dependencies: [
            .Project.Feature.Features,
            .Project.InjectionManager.InjectionManager
        ],
        settings: .settings(
            base: [
                // FlexLayout 사용 시 주석 해제
//                "OTHER_LDFLAGS": ["-lc++", "-Objc"],
//                "GCC_PREPROCESSOR_DEFINITIONS": ["FLEXLAYOUT_SWIFT_PACKAGE=1"]
            ],
            configurations: [
                .debug(
                    name: .DEV,
                    settings: [
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDev",
                        "PRODUCT_BUNDLE_IDENTIFIER": "\(organizationName)-Dev",
                        "PRODUCT_NAME": "\(projectName)-Dev"
                    ],
                    xcconfig: .XCConfig.app(.DEV)
                ),
                .release(
                    name: .PROD,
                    settings: [
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE",
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                        "PRODUCT_BUNDLE_IDENTIFIER": "\(organizationName)",
                        "PRODUCT_NAME": "\(projectName)"
                    ],
                    xcconfig: .XCConfig.app(.PROD)
                )
            ]
        ),
        launchArguments: [
            .launchArgument(
                "IDEPreferLogStreaming",
                isEnabled: true
            )
        ]
    ),
    .target(
        name: "\(projectName)Tests"
        destinations: .iOS,
        product: .unitTests,
        productName: "\(projectName)Tests",
        bundleId: "\(organizationName)Tests",
        deploymentTargets: deploymentTargets,
        infoPlist: .default,
        sources: ["Tests/**"],
        entitlements: "../../SupportingFiles/F1Manager.entitlements",
        dependencies: [
            .target(name: projectName)
        ],
        settings: .settings(
            base: [
                // FlexLayout 사용 시 주석 해제
//                "OTHER_LDFLAGS": ["-lc++", "-Objc"],
//                "GCC_PREPROCESSOR_DEFINITIONS": ["FLEXLAYOUT_SWIFT_PACKAGE=1"]
            ],
            configurations: [
                .debug(
                    name: .TEST_DEV,
                    settings: [
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDev",
                        "PRODUCT_BUNDLE_IDENTIFIER": "\(organizationName)Tests-Dev",
                        "PRODUCT_NAME": "\(projectName)Tests-Dev"
                    ],
                    xcconfig: .XCConfig.app(.TEST_DEV)
                ),
                .debug(
                    name: .TEST_PROD,
                    settings: [
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDev",
                        "PRODUCT_BUNDLE_IDENTIFIER": "\(organizationName)Tests",
                        "PRODUCT_NAME": "\(projectName)Tests"
                    ],
                    xcconfig: .XCConfig.app(.TEST_PROD)
                ),
            ]
        ),
        launchArguments: [
            .launchArgument(
                name: "IDEPreferLogStreaming",
                isEnabled: true
            )
        ]
    )
]

// MARK: - Schemes
let schemes: [Scheme] = [
    
]

// MARK: - Project
let project: Project = .init(
    name: "Application",
    organizationName: organizationName,
    options: .options(
        defaultKnownRegions: [
            "en",
            "ko"
        ],
        developmentRegion: "ko"
    ),
    settings: settings,
    targets: targets,
    schemes: schemes,
    additionalFiles: [
        "//XCConfig/Application/Application-\(AppConfiguration.SHARED).xcconfig"
    ]
)
