// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "xcode-simulator-cert",
    products: [
       .executable(
           name: "xcode-simulator-cert",
           targets: ["xcode-simulator-cert"]
       )
    ],
    dependencies: [
        // There is no tagged release of Swift 5's SwiftPM yet, so let's use this for now.
        .package(url: "https://github.com/apple/swift-package-manager.git", .branch("swift-5.0-branch")),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.12.0")
    ],
    targets: [
        .target(
            name: "xcode-simulator-cert",
            dependencies: [
                "XcodeSimulatorKit"
            ]),
        .testTarget(
            name: "xcode-simulator-certTests",
            dependencies: [
                "xcode-simulator-cert"
            ]),
        .target(
            name: "XcodeSimulatorKit",
            dependencies: [
                "SPMUtility",
                "SQLite"
            ]
        ),

    ]
)
