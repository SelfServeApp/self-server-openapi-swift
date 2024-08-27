// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "self-server-openapi-swift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SelfServerRESTTypes",
            targets: ["SelfServerRESTTypes"]
        ),
        .library(
            name: "SelfServerRESTClientStubs",
            targets: ["SelfServerRESTClientStubs"]
        ),
        .library(
            name: "SelfServerRESTServerStubs",
            targets: ["SelfServerRESTServerStubs"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SelfServerRESTTypes",
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
