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
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.3.0")
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
                "Utility"
            ]
        ),

    ]
)
