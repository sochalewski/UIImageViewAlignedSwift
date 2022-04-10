// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "UIImageViewAlignedSwift",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "UIImageViewAlignedSwift",
            targets: ["UIImageViewAlignedSwift"]
        )
    ],
    targets: [
        .target(
            name: "UIImageViewAlignedSwift",
            path: ".",
            exclude: [
                "README.md",
                "UIImageViewAlignedSwift",
                "LICENSE",
                "UIImageViewAlignedSwift.podspec"
            ],
            sources: ["UIImageViewAligned.swift"]
        )
    ]
)
