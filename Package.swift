// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftShell",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(name: "SwiftShell", targets: ["SwiftShell"]),
    ],
    targets: [
        .target(
            name: "SwiftShell"
        ),
        .executableTarget(
            name: "SwiftShellExample",
            dependencies: ["SwiftShell"]
        ),
        .testTarget(
            name: "SwiftShellTests",
            dependencies: ["SwiftShell"]
        )
    ]
)
