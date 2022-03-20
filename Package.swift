// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SimpleRoulette",
    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],
    products: [
        .library(
            name: "SimpleRoulette",
            targets: ["SimpleRoulette"]),
    ],
    targets: [
        .target(
            name: "SimpleRoulette",
            dependencies: []
        )
    ]
)
