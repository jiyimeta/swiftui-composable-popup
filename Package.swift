// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftui-composable-popup",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "ComposablePopup",
            targets: ["ComposablePopup"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", "1.5.0" ..< "2.0.0"),
    ],
    targets: [
        .target(
            name: "ComposablePopup",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "ComposablePopupTests",
            dependencies: [
                "ComposablePopup",
            ]
        ),
    ]
)
