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
