// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iShape-swift",
    products: [
        .library(
            name: "iShape-swift",
            targets: ["iShape-swift"]
        ),
    ],
    targets: [
        .target(
            name: "iShapeFFI",
            publicHeadersPath: "include",
            linkerSettings: [
                .linkedLibrary("i_shape_ffi"),
                .unsafeFlags(
                    ["-L", "Sources/iShapeFFI/lib/macos"],
                    .when(platforms: [.macOS])
                ),
                .unsafeFlags(
                    ["-L", "Sources/iShapeFFI/lib/ios/device", "-L", "Sources/iShapeFFI/lib/ios/simulator"],
                    .when(platforms: [.iOS])
                )
            ]
        ),
        .target(
            name: "iShape-swift",
            dependencies: ["iShapeFFI"]
        ),
        .testTarget(
            name: "iShape-swiftTests",
            dependencies: ["iShape-swift"]
        ),
    ]
)
