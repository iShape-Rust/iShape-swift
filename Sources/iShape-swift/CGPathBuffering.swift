import CoreGraphics
import iShapeFFI

public enum CGPathBuffering {
    public static func offsetContours(
        path: CGPath,
        distance: CGFloat,
        style: StrokeOffsetStyle = .default
    ) -> CGPointShapes? {
        guard distance > 0 else {
            return nil
        }
        guard let contours = extractLineContours(from: path), !contours.isEmpty else {
            return nil
        }

        var allShapes: CGPointShapes = []
        let buffer = FlatF64ShapesBuffer()
        let width = Double(distance * 2)

        for contour in contours {
            if contour.points.count < (contour.isClosed ? 3 : 2) {
                continue
            }

            var flat: [Double] = []
            flat.reserveCapacity(contour.points.count * 2)
            for point in contour.points {
                flat.append(Double(point.x))
                flat.append(Double(point.y))
            }

            let success = flat.withUnsafeBufferPointer { pointsBuffer -> Bool in
                ishape_handle_stroke_f64_contour_to_flat_styled(
                    pointsBuffer.baseAddress,
                    pointsBuffer.count,
                    width,
                    contour.isClosed,
                    style.lineJoin.ffiValue.kind,
                    style.lineJoin.ffiValue.value,
                    style.startCap.ffiValue.kind,
                    style.startCap.ffiValue.value,
                    style.endCap.ffiValue.kind,
                    style.endCap.ffiValue.value,
                    buffer.rawPointer
                )
            }

            guard success else {
                return nil
            }

            let shapes = buffer.toCGPointShapes()
            if !shapes.isEmpty {
                allShapes.append(contentsOf: shapes)
            }
        }

        return allShapes.isEmpty ? nil : allShapes
    }

    public static func offsetPath(
        path: CGPath,
        distance: CGFloat,
        style: StrokeOffsetStyle = .default
    ) -> CGPath? {
        guard let shapes = offsetContours(path: path, distance: distance, style: style) else {
            return nil
        }

        return shapesToPath(shapes)
    }
}

public enum CGPointStrokeOffset {
    public static func offsetContours(
        points: [CGPoint],
        distance: CGFloat,
        isClosedPath: Bool = true,
        style: StrokeOffsetStyle = .default
    ) -> CGPointShapes? {
        guard distance > 0 else {
            return nil
        }

        let normalized = normalizeContour(points)
        let minCount = isClosedPath ? 3 : 2
        guard normalized.count >= minCount else {
            return nil
        }

        var flat: [Double] = []
        flat.reserveCapacity(normalized.count * 2)
        for point in normalized {
            flat.append(Double(point.x))
            flat.append(Double(point.y))
        }

        let buffer = FlatF64ShapesBuffer()
        let width = Double(distance * 2)

        let success = flat.withUnsafeBufferPointer { pointsBuffer -> Bool in
            ishape_handle_stroke_f64_contour_to_flat_styled(
                pointsBuffer.baseAddress,
                pointsBuffer.count,
                width,
                isClosedPath,
                style.lineJoin.ffiValue.kind,
                style.lineJoin.ffiValue.value,
                style.startCap.ffiValue.kind,
                style.startCap.ffiValue.value,
                style.endCap.ffiValue.kind,
                style.endCap.ffiValue.value,
                buffer.rawPointer
            )
        }

        guard success else {
            return nil
        }

        let shapes = buffer.toCGPointShapes()
        return shapes.isEmpty ? nil : shapes
    }

    public static func offsetPath(
        points: [CGPoint],
        distance: CGFloat,
        isClosedPath: Bool = true,
        style: StrokeOffsetStyle = .default
    ) -> CGPath? {
        guard let shapes = offsetContours(
            points: points,
            distance: distance,
            isClosedPath: isClosedPath,
            style: style
        ) else {
            return nil
        }

        return shapesToPath(shapes)
    }
}

private extension CGPathBuffering {
    struct ExtractedContour {
        var points: CGPointContour
        var isClosed: Bool
    }

    static func extractLineContours(from path: CGPath) -> [ExtractedContour]? {
        var contours: [ExtractedContour] = []
        var current: CGPointContour = []
        var supported = true
        var currentIsClosed = false

        path.forEachElement { element in
            switch element.type {
            case .moveToPoint:
                if !current.isEmpty {
                    contours.append(ExtractedContour(
                        points: normalizeContour(current),
                        isClosed: currentIsClosed
                    ))
                }
                current = [element.points[0]]
                currentIsClosed = false
            case .addLineToPoint:
                if current.isEmpty {
                    current = [element.points[0]]
                } else {
                    current.append(element.points[0])
                }
            case .closeSubpath:
                if !current.isEmpty {
                    contours.append(ExtractedContour(
                        points: normalizeContour(current),
                        isClosed: true
                    ))
                    current = []
                }
                currentIsClosed = true
            case .addQuadCurveToPoint, .addCurveToPoint:
                supported = false
            @unknown default:
                supported = false
            }
        }

        if !supported {
            return nil
        }

        if !current.isEmpty {
            contours.append(ExtractedContour(
                points: normalizeContour(current),
                isClosed: currentIsClosed
            ))
        }

        return contours
    }

}

@inline(__always)
private func shapesToPath(_ shapes: CGPointShapes) -> CGPath? {
    let output = CGMutablePath()
    for shape in shapes {
        for contour in shape {
            guard let first = contour.first else {
                continue
            }
            output.move(to: first)
            for point in contour.dropFirst() {
                output.addLine(to: point)
            }
            output.closeSubpath()
        }
    }
    return output.copy()
}

@inline(__always)
private func normalizeContour(_ contour: CGPointContour) -> CGPointContour {
    guard contour.count >= 2 else {
        return contour
    }

    if pointsNear(contour.first!, contour.last!) {
        return Array(contour.dropLast())
    }

    return contour
}

@inline(__always)
private func pointsNear(_ a: CGPoint, _ b: CGPoint, epsilon: CGFloat = 1e-9) -> Bool {
    abs(a.x - b.x) <= epsilon && abs(a.y - b.y) <= epsilon
}

private extension CGPath {
    func forEachElement(_ body: (CGPathElement) -> Void) {
        applyWithBlock { elementPointer in
            body(elementPointer.pointee)
        }
    }
}
