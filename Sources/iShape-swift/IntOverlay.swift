import iShapeFFI

@usableFromInline
typealias IntOverlayHandle = UnsafeMutableRawPointer

public final class IntOverlay: @unchecked Sendable {
    @usableFromInline
    internal let handle: IntOverlayHandle

    public init(capacity: Int = 0, options: IntOverlayOptions = .default) {
        guard let pointer = ishape_handle_overlay_int_create(
            max(capacity, 0),
            options.ffiValue
        ) else {
            fatalError("Failed to allocate IntOverlay")
        }
        self.handle = pointer
    }

    deinit {
        ishape_handle_overlay_int_free(handle)
    }

    @discardableResult
    public func addContour(points: [Int32], shapeType: ShapeType) -> Bool {
        guard !points.isEmpty else {
            return false
        }
        guard points.count % 2 == 0 else {
            return false
        }
        return points.withUnsafeBufferPointer { buffer -> Bool in
            ishape_handle_overlay_int_add_contour(
                handle,
                buffer.baseAddress,
                buffer.count,
                shapeType.ffiValue
            )
        }
    }

    @discardableResult
    public func addContour(_ contour: IntContour, shapeType: ShapeType) -> Bool {
        guard !contour.isEmpty else {
            return false
        }
        var flat: [Int32] = []
        flat.reserveCapacity(contour.count * 2)
        for point in contour {
            flat.append(point.x)
            flat.append(point.y)
        }
        return addContour(points: flat, shapeType: shapeType)
    }

    @discardableResult
    public func addShape(_ shape: IntShape, shapeType: ShapeType) -> Bool {
        for contour in shape {
            if !addContour(contour, shapeType: shapeType) {
                return false
            }
        }
        return true
    }

    @discardableResult
    public func addShapes(_ shapes: IntShapes, shapeType: ShapeType) -> Bool {
        for shape in shapes {
            if !addShape(shape, shapeType: shapeType) {
                return false
            }
        }
        return true
    }

    @discardableResult
    public func overlay(
        overlayRule: OverlayRule,
        fillRule: FillRule,
        output: FlatShapesBuffer
    ) -> Bool {
        ishape_handle_overlay_int_overlay_into_flat(
            handle,
            overlayRule.ffiValue,
            fillRule.ffiValue,
            output.rawPointer
        )
    }

    public func overlay(
        overlayRule: OverlayRule,
        fillRule: FillRule
    ) -> IntShapes? {
        let buffer = FlatShapesBuffer()
        guard overlay(overlayRule: overlayRule, fillRule: fillRule, output: buffer) else {
            return nil
        }
        return buffer.toIntShapes()
    }
}

public extension IntOverlay {
    @discardableResult
    func addSubject(_ shapes: IntShapes) -> Bool {
        addShapes(shapes, shapeType: .subject)
    }

    @discardableResult
    func addClip(_ shapes: IntShapes) -> Bool {
        addShapes(shapes, shapeType: .clip)
    }
}
