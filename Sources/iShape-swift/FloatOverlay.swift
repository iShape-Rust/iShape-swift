import CoreGraphics
import iShapeFFI

@usableFromInline
typealias F64OverlayHandle = UnsafeMutableRawPointer

public final class FloatOverlay: @unchecked Sendable {
    @usableFromInline
    internal let handle: F64OverlayHandle

    public init(capacity: Int = 0, options: FloatOverlayOptions = .default) {
        guard let pointer = ishape_handle_overlay_f64_create(
            max(capacity, 0),
            options.ffiValue
        ) else {
            fatalError("Failed to allocate FloatOverlay")
        }
        self.handle = pointer
    }

    deinit {
        ishape_handle_overlay_f64_free(handle)
    }

    @discardableResult
    public func addContour(points: [Double], shapeType: ShapeType) -> Bool {
        guard !points.isEmpty else {
            return false
        }
        guard points.count % 2 == 0 else {
            return false
        }
        return points.withUnsafeBufferPointer { buffer -> Bool in
            ishape_handle_overlay_f64_add_contour(
                handle,
                buffer.baseAddress,
                buffer.count,
                shapeType.ffiValue
            )
        }
    }

    @discardableResult
    public func addContour(_ contour: CGPointContour, shapeType: ShapeType) -> Bool {
        guard !contour.isEmpty else {
            return false
        }
        var flat: [Double] = []
        flat.reserveCapacity(contour.count * 2)
        for point in contour {
            flat.append(Double(point.x))
            flat.append(Double(point.y))
        }
        return addContour(points: flat, shapeType: shapeType)
    }

    @discardableResult
    public func addShape(_ shape: CGPointShape, shapeType: ShapeType) -> Bool {
        for contour in shape {
            if !addContour(contour, shapeType: shapeType) {
                return false
            }
        }
        return true
    }

    @discardableResult
    public func addShapes(_ shapes: CGPointShapes, shapeType: ShapeType) -> Bool {
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
        output: FlatF64ShapesBuffer
    ) -> Bool {
        ishape_handle_overlay_f64_overlay_into_flat(
            handle,
            overlayRule.ffiValue,
            fillRule.ffiValue,
            output.rawPointer
        )
    }

    public func overlay(
        overlayRule: OverlayRule,
        fillRule: FillRule
    ) -> CGPointShapes? {
        let buffer = FlatF64ShapesBuffer()
        guard overlay(overlayRule: overlayRule, fillRule: fillRule, output: buffer) else {
            return nil
        }
        return buffer.toCGPointShapes()
    }
}

public extension FloatOverlay {
    @discardableResult
    func addSubject(_ shapes: CGPointShapes) -> Bool {
        addShapes(shapes, shapeType: .subject)
    }

    @discardableResult
    func addClip(_ shapes: CGPointShapes) -> Bool {
        addShapes(shapes, shapeType: .clip)
    }
}
