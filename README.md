# iShapeKit

2D polygon geometry for Swift, powered by the Rust iOverlay and iTriangle libraries through [iShape-ffi](https://github.com/iShape-Rust/iShape-ffi). Use it in drawing apps, vector editors, map tools, or games to combine shapes, build outlines, and prepare convex polygons for collision geometry.

The package provides native `CGPoint` and integer APIs with a bundled XCFramework. Rust handles the geometry; Swift manages the library handles. You can use it without installing Rust, and reuse flat buffers to reduce allocations in repeated operations.

## Features

| Task | API |
| --- | --- |
| Union, intersection, difference, XOR; polygons with holes | `FloatOverlay`, `IntOverlay` |
| Expand or shrink closed shapes | `CGPointOutlineOffset` |
| Stroke paths with constant or per-vertex width | `CGPointStrokeOffset`, `CGPointVariableStrokeOffset` |
| Stroke a `CGPath` made of line segments | `CGPathBuffering` |
| Split shapes into non-overlapping convex polygons | `CGPointConvexDecomposition` |
| Get nesting links between Boolean result shapes | `FloatOverlay.overlayHierarchy` |

## Installation

Requires Swift 6.2+, iOS 16+ or macOS 11+. Add version `0.2.7` through Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/iShape-Rust/iShape-swift.git", from: "0.2.7")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [.product(name: "iShapeKit", package: "iShape-swift")]
    )
]
```

## Quick start

Combine two rectangles:

```swift
import CoreGraphics
import iShapeKit

let subject: CGPointShape = [[
    CGPoint(x: 0, y: 0), CGPoint(x: 4, y: 0),
    CGPoint(x: 4, y: 4), CGPoint(x: 0, y: 4)
]]
let clip: CGPointShape = [[
    CGPoint(x: 2, y: 0), CGPoint(x: 6, y: 0),
    CGPoint(x: 6, y: 4), CGPoint(x: 2, y: 4)
]]

let overlay = FloatOverlay()
overlay.addSubject([subject])
overlay.addClip([clip])

if let shapes = overlay.overlay(overlayRule: .union, fillRule: .evenOdd) {
    print(shapes.count) // 1 merged shape
}

// Expand a shape or split it into convex pieces.
let expanded = CGPointOutlineOffset.offsetShape(shape: subject, distance: 1)
let convex = CGPointConvexDecomposition.toConvexPolygons(shape: subject)
```

A contour is `[CGPoint]`; a shape is an array of contours (outer boundary followed by holes); a shapes collection is an array of shapes. Contours are implicitly closed. Use `.evenOdd` to interpret holes by nesting, or `.nonZero` with the appropriate contour winding.

For integer coordinates, use `IntOverlay` and `IntPoint`. For repeated calls, pass a reusable `FlatShapesBuffer` or `FlatF64ShapesBuffer` as the output. Buffer-based offsets and convex decomposition require distinct input and output buffers.

Outline offsets use positive distances to expand outer contours and negative distances to shrink them. Stroke `distance` is half the full width; variable-stroke vertices specify the full width. Joins and caps are configurable through `OutlineOffsetStyle` and `StrokeOffsetStyle`; angle parameters are in radians. `CGPathBuffering` accepts line segments only; flatten curves before passing them in.

## Development

To rebuild the bundled libraries, keep `iShape-ffi` and `iShape-swift` as sibling directories. On macOS with Xcode and Rust installed, run from this repository:

```bash
./build_ffi.sh
swift build
swift test
```

The script builds macOS (arm64/x86_64), iOS devices (arm64), and iOS simulators (arm64/x86_64), then packages the static libraries into an XCFramework. Rebuild whenever the Rust implementation or C header changes.
