// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iShapeKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "iShapeKit",
            targets: ["iShapeKit"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "iShapeFFIRustLib",
            path: "Sources/iShapeFFI/lib/i_shape_ffi.xcframework"
        ),
        .target(
            name: "iShapeFFI",
            dependencies: ["iShapeFFIRustLib"],
            publicHeadersPath: "include"
        ),
        .target(
            name: "iShapeKit",
            dependencies: ["iShapeFFI"],
            path: "Sources/iShape-swift"
        ),
        .testTarget(
            name: "iShape-swiftTests",
            dependencies: ["iShapeKit"]
        ),
    ]
)
