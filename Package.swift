// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "self-server-openapi-swift",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "self-server-openapi-swift",
            targets: ["self-server-openapi-swift"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "self-server-openapi-swift"),
        .testTarget(
            name: "self-server-openapi-swiftTests",
            dependencies: ["self-server-openapi-swift"]),
    ]
)
