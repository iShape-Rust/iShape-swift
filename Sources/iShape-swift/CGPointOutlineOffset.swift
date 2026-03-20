import CoreGraphics

@frozen
public struct OutlineOffsetStyle: Sendable {
    public var lineJoin: StrokeLineJoin

    public init(lineJoin: StrokeLineJoin = .bevel) {
        self.lineJoin = lineJoin
    }
}

public extension OutlineOffsetStyle {
    static let `default` = OutlineOffsetStyle()
}

public enum CGPointOutlineOffset {
    public static func offsetContours(
        points: [CGPoint],
        distance: CGFloat,
        style: OutlineOffsetStyle = .default
    ) -> CGPointShapes? {
        offsetShape(contours: [points], distance: distance, style: style)
    }

    public static func offsetContours(
        contours: CGPointShape,
        distance: CGFloat,
        style: OutlineOffsetStyle = .default
    ) -> CGPointShapes? {
        offsetShape(contours: contours, distance: distance, style: style)
    }

    public static func offsetShape(
        contours: CGPointShape,
        distance: CGFloat,
        style: OutlineOffsetStyle = .default
    ) -> CGPointShapes? {
        guard distance != 0 else {
            return nil
        }

        var normalizedContours: CGPointShape = []
        normalizedContours.reserveCapacity(contours.count)
        for contour in contours {
            let normalized = normalizeOutlineContour(contour)
            if normalized.count >= 3 {
                normalizedContours.append(normalized)
            }
        }

        guard !normalizedContours.isEmpty else {
            return nil
        }

        let absDistance = abs(distance)
        let strokeStyle = StrokeOffsetStyle(lineJoin: style.lineJoin, lineCap: .butt)
        var strokeShapes: CGPointShapes = []
        strokeShapes.reserveCapacity(normalizedContours.count)

        for contour in normalizedContours {
            guard let contourStroke = CGPointStrokeOffset.offsetContours(
                points: contour,
                distance: absDistance,
                isClosedPath: true,
                style: strokeStyle
            ) else {
                return nil
            }

            if !contourStroke.isEmpty {
                strokeShapes.append(contentsOf: contourStroke)
            }
        }

        let overlay = FloatOverlay()
        guard overlay.addShape(normalizedContours, shapeType: .subject) else {
            return nil
        }

        if distance > 0 {
            if !strokeShapes.isEmpty {
                guard overlay.addShapes(strokeShapes, shapeType: .subject) else {
                    return nil
                }
            }

            return overlay.overlay(overlayRule: .subject, fillRule: .evenOdd)
        }

        if !strokeShapes.isEmpty {
            guard overlay.addShapes(strokeShapes, shapeType: .clip) else {
                return nil
            }
        }

        return overlay.overlay(overlayRule: .difference, fillRule: .evenOdd)
    }
}

@inline(__always)
private func normalizeOutlineContour(_ contour: CGPointContour) -> CGPointContour {
    guard contour.count >= 2 else {
        return contour
    }

    if outlinePointsNear(contour.first!, contour.last!) {
        return Array(contour.dropLast())
    }

    return contour
}

@inline(__always)
private func outlinePointsNear(_ a: CGPoint, _ b: CGPoint, epsilon: CGFloat = 1e-9) -> Bool {
    abs(a.x - b.x) <= epsilon && abs(a.y - b.y) <= epsilon
}
