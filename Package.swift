// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let packageRoot = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path
let macLibPath = "\(packageRoot)/Sources/iShapeFFI/lib/macos"
let iosDeviceLibPath = "\(packageRoot)/Sources/iShapeFFI/lib/ios/device"
let iosSimLibPath = "\(packageRoot)/Sources/iShapeFFI/lib/ios/simulator"

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
                    ["-L", macLibPath],
                    .when(platforms: [.macOS])
                ),
                .unsafeFlags(
                    ["-L", iosDeviceLibPath, "-L", iosSimLibPath],
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
