// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZiyonUtility",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ZiyonUtility",
            targets: ["ZiyonUtility"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
                   name: "ZiyonUtility",
                   dependencies: [],
                   path: "ZiyonUtility/Sources/ZiyonUtility",
                   resources: [
                    .copy("Resources/Fonts/Didot.ttc"),
                    .copy("Resources/Fonts/Roboto-Black.ttf"),
                    .copy("Resources/Fonts/Roboto-Bold.ttf"),
                    .copy("Resources/Fonts/Roboto-Light.ttf"),
                    .copy("Resources/Fonts/Roboto-Medium.ttf"),
                    .copy("Resources/Fonts/Roboto-Regular.ttf"),
                    .copy("Resources/Fonts/Roboto-Thin.ttf")
                   ]),
        .testTarget(
            name: "ZiyonUtilityTests",
            dependencies: ["ZiyonUtility"],
            path: "ZiyonUtility/Tests/ZiyonUtilityTests"),
    ]
)
