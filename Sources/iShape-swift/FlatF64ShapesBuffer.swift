import CoreGraphics
import iShapeFFI

@usableFromInline
typealias FlatF64ShapesHandle = UnsafeMutableRawPointer

public final class FlatF64ShapesBuffer: @unchecked Sendable {
    @usableFromInline
    internal let handle: FlatF64ShapesHandle

    public init() {
        guard let pointer = ishape_handle_flat_f64_shapes_create() else {
            fatalError("Failed to allocate FlatF64ShapesBuffer")
        }
        self.handle = pointer
    }

    public init(pointsCapacity: Int, contoursCapacity: Int, shapesCapacity: Int) {
        guard let pointer = ishape_handle_flat_f64_shapes_with_capacity(
            max(pointsCapacity, 0),
            max(contoursCapacity, 0),
            max(shapesCapacity, 0)
        ) else {
            fatalError("Failed to allocate FlatF64ShapesBuffer with capacity")
        }
        self.handle = pointer
    }

    deinit {
        ishape_handle_flat_f64_shapes_free(handle)
    }

    @inlinable
    public func clear() {
        ishape_handle_flat_f64_shapes_clear(handle)
    }

    @inlinable
    public var pointCount: Int {
        Int(ishape_handle_flat_f64_shapes_points_len(handle))
    }

    @inlinable
    public var contourCount: Int {
        Int(ishape_handle_flat_f64_shapes_contours_len(handle))
    }

    @inlinable
    public var shapeCount: Int {
        Int(ishape_handle_flat_f64_shapes_shapes_len(handle))
    }

    public func toCGPointShapes() -> CGPointShapes {
        let pointLength = pointCount
        let contourLength = contourCount
        let shapeLength = shapeCount

        let points: [Double]
        if pointLength > 0, let pointer = ishape_handle_flat_f64_shapes_points_ptr(handle) {
            points = Array(UnsafeBufferPointer(start: pointer, count: pointLength))
        } else {
            points = []
        }

        let contourRanges: [RangeFFI]
        if contourLength > 0, let pointer = ishape_handle_flat_f64_shapes_contours_ptr(handle) {
            contourRanges = Array(UnsafeBufferPointer(start: pointer, count: contourLength))
        } else {
            contourRanges = []
        }

        let shapeRanges: [RangeFFI]
        if shapeLength > 0, let pointer = ishape_handle_flat_f64_shapes_shapes_ptr(handle) {
            shapeRanges = Array(UnsafeBufferPointer(start: pointer, count: shapeLength))
        } else {
            shapeRanges = []
        }

        if shapeRanges.isEmpty {
            return []
        }

        return FlatF64ShapesBuffer.decodeShapes(
            points: points,
            contourRanges: contourRanges,
            shapeRanges: shapeRanges
        )
    }

    @usableFromInline
    internal var rawPointer: FlatF64ShapesHandle {
        handle
    }
}

private extension FlatF64ShapesBuffer {
    static func decodeShapes(
        points: [Double],
        contourRanges: [RangeFFI],
        shapeRanges: [RangeFFI]
    ) -> CGPointShapes {
        var shapes: CGPointShapes = []
        shapes.reserveCapacity(shapeRanges.count)

        for shapeRange in shapeRanges {
            let lower = shapeRange.lowerBoundIndex
            let upper = shapeRange.upperBoundIndex

            guard lower <= upper else {
                continue
            }

            var shape: CGPointShape = []
            shape.reserveCapacity(upper - lower)

            for index in lower..<upper {
                guard index < contourRanges.count else {
                    break
                }
                let contourRange = contourRanges[index]
                shape.append(makeContour(range: contourRange, points: points))
            }

            if !shape.isEmpty {
                shapes.append(shape)
            }
        }

        return shapes
    }

    static func makeContour(range: RangeFFI, points: [Double]) -> CGPointContour {
        let lower = range.lowerBoundIndex
        let upper = range.upperBoundIndex

        if lower >= upper || upper > points.count {
            return []
        }

        let pairCount = (upper - lower) / 2
        var contour: CGPointContour = []
        contour.reserveCapacity(max(pairCount, 0))

        var index = lower
        while index + 1 < upper {
            let x = points[index]
            let y = points[index + 1]
            contour.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
            index += 2
        }

        return contour
    }
}
