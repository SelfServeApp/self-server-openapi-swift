// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "self-server-openapi-swift",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SelfServerRESTTypes",
            targets: ["SelfServerRESTTypes"]
        ),
        .library(
            name: "SelfServerRESTClientStubs",
            targets: ["SelfServerRESTClientStubs", "SelfServerRESTTypes"]
        ),
        .library(
            name: "SelfServerRESTServerStubs",
            targets: ["SelfServerRESTServerStubs", "SelfServerRESTTypes"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        
        .package(url: "https://github.com/edonv/swift-http-field-types.git", from: "0.1.0"),
        .package(url: "https://github.com/SelfServeApp/self-server-extensions.git", from: "0.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SelfServerRESTTypes",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "HTTPFieldTypes", package: "swift-http-field-types"),
                .product(name: "SelfServerExtensions", package: "self-server-extensions"),
                .product(name: "SelfServerHelperTypes", package: "self-server-extensions"),
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
            ]
        ),
        .target(
            name: "SelfServerRESTClientStubs",
            dependencies: [
                "SelfServerRESTTypes",
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
            ]
        ),
        .target(
            name: "SelfServerRESTServerStubs",
            dependencies: [
                "SelfServerRESTTypes",
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
            ]
        ),
        .testTarget(
            name: "SelfServerRESTTypesTests",
            dependencies: ["SelfServerRESTTypes"]
        ),
    ]
)
