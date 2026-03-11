// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "pbedit",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "PBEditCore",
            dependencies: [],
            linkerSettings: [
                .linkedFramework("AppKit"),
            ]
        ),
        .executableTarget(
            name: "pbedit",
            dependencies: [
                "PBEditCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .executableTarget(
            name: "PBEditApp",
            dependencies: [
                "PBEditCore",
            ],
            linkerSettings: [
                .linkedFramework("Carbon"),
            ]
        ),
    ]
)
