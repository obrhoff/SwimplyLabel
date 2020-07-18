// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwimplyLabel",
    platforms: [
        .iOS(.v10), .macOS(.v10_12), .tvOS(.v10),
    ],
    products: [
        .library(
            name: "SwimplyLabel",
            targets: ["SwimplyLabel"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/docterd/SwimplyCache.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "DOLabel",
            dependencies: ["SwimplyCache"]
        ),
    ]
)
