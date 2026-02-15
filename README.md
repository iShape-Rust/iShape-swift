# iShape-swift

Swift Package that bridges the [iShape Rust geometry toolkit](https://github.com/iShape-Rust/iShape) (via the bundled [`i_shape_ffi`](https://github.com/iShape-Rust/iShape/tree/main/iShape-ffi) crate) into native Swift APIs. It ships prebuilt static libraries plus thin Swift wrappers so you can run high-performance polygon Boolean operations on Apple platforms without touching Rust directly.

Rebuild the FFI artifacts whenever you change the Rust sources:

```bash
cd iShape-swift
./build_ffi.sh
```

Then build or test with SwiftPM (the script emits static libs for macOS, iOS device, and iOS simulator):

```bash
CLANG_MODULE_CACHE_PATH=$(pwd)/.cache/clang swift build --disable-sandbox
CLANG_MODULE_CACHE_PATH=$(pwd)/.cache/clang swift test --disable-sandbox
```

### Quick Start

```swift
import iShape_swift

let overlay = IntOverlay()

// Add one subject shape (outer contour plus a hole).
overlay.addSubject([[
    [IntPoint(0, 0), IntPoint(0, 10), IntPoint(10, 10), IntPoint(10, 0)],
    [IntPoint(4, 4), IntPoint(4, 6), IntPoint(6, 6), IntPoint(6, 4)],
]])

overlay.addClip([[
    [IntPoint(5, 0), IntPoint(5, 10), IntPoint(12, 10), IntPoint(12, 0)],
]])

let buffer = FlatShapesBuffer()
overlay.overlay(overlayRule: .union, fillRule: .evenOdd, output: buffer)

let shapes: IntShapes = buffer.toIntShapes()
print(shapes.count)      // -> 1
print(shapes[0].count)   // -> outer contour + one hole
```

`FlatShapesBuffer` can be reused across calls and passed over the FFI boundary, while the high-level helpers return Swift-native `[[[IntPoint]]]` structures for convenience.

### Float / CGPoint API

`FloatOverlay` mirrors the integer API, but takes and returns `CGPoint`:

```swift
import CoreGraphics
import iShape_swift

let overlay = FloatOverlay()
overlay.addSubject([[
    [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 4), CGPoint(x: 4, y: 4), CGPoint(x: 4, y: 0)],
]])
overlay.addClip([[
    [CGPoint(x: 2, y: 0), CGPoint(x: 2, y: 4), CGPoint(x: 6, y: 4), CGPoint(x: 6, y: 0)],
]])

let result: CGPointShapes? = overlay.overlay(overlayRule: .union, fillRule: .evenOdd)
```
