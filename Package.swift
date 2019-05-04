// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "xcode-simulator-tool",
    products: [
       .executable(
           name: "xcode-simulator-tool",
           targets: ["xcode-simulator-tool"]
       )
    ],
    dependencies: [
        // There is no tagged release of Swift 5's SwiftPM yet, so let's use this for now.
        .package(url: "https://github.com/apple/swift-package-manager.git", .branch("swift-5.0-branch"))
    ],
    targets: [
        .target(
            name: "xcode-simulator-tool",
            dependencies: [
                "XcodeSimulatorKit"
            ]),
        .testTarget(
            name: "xcode-simulator-toolTests",
            dependencies: [
                "xcode-simulator-tool"
            ]),
        .target(
            name: "XcodeSimulatorKit",
            dependencies: [
                "SPMUtility"
            ]
        ),

    ]
)
