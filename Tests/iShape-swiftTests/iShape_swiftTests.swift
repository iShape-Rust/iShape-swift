import CoreGraphics
import Testing
@testable import iShape_swift

@Test func test_0() {
    let overlay = IntOverlay()
    overlay.addSubject([[
        [
            IntPoint(0, 0),
            IntPoint(0, 4),
            IntPoint(4, 4),
            IntPoint(4, 0),
        ],
        [
            IntPoint(4, 0),
            IntPoint(4, 4),
            IntPoint(8, 4),
            IntPoint(8, 0),
        ]
    ]])
    let result = overlay.overlay(overlayRule: .subject, fillRule: .nonZero)
    
    assert(result != nil)
    let shapes = result!
    
    assert(shapes.count == 1)
    assert(shapes[0].count == 1)
    assert(shapes[0][0].count == 4)
}

@Test func testDifferenceProducesHole() {
    let overlay = IntOverlay()
    overlay.addSubject([[ 
        [
            IntPoint(0, 0),
            IntPoint(0, 6),
            IntPoint(6, 6),
            IntPoint(6, 0),
        ],
    ]])
    overlay.addClip([[ 
        [
            IntPoint(2, 2),
            IntPoint(2, 4),
            IntPoint(4, 4),
            IntPoint(4, 2),
        ],
    ]])

    let buffer = FlatShapesBuffer()
    let success = overlay.overlay(
        overlayRule: .difference,
        fillRule: .evenOdd,
        output: buffer
    )

    assert(success == true)

    let shapes = buffer.toIntShapes()
    assert(shapes.count == 1)
    let shape = shapes[0]
    assert(shape.count == 2)
    assert(shape[0].count == 4)
    assert(shape[1].count == 4)
}

@Test func testOverlayIntoFlatBufferReuse() {
    let buffer = FlatShapesBuffer()
    let overlay = IntOverlay()
    overlay.addSubject([[ 
        [
            IntPoint(0, 0),
            IntPoint(3, 0),
            IntPoint(3, 3),
            IntPoint(0, 3),
        ],
    ]])

    assert(overlay.overlay(
        overlayRule: .subject,
        fillRule: .nonZero,
        output: buffer
    ))
    assert(buffer.shapeCount == 1)
    assert(buffer.contourCount == 1)
    assert(buffer.pointCount == 8)

    let emptyOverlay = IntOverlay()
    assert(emptyOverlay.overlay(
        overlayRule: .subject,
        fillRule: .evenOdd,
        output: buffer
    ))
    assert(buffer.shapeCount == 0)
    assert(buffer.contourCount == 0)
    assert(buffer.pointCount == 0)
}

@Test func testRejectsOddCoordinateCount() {
    let overlay = IntOverlay()
    let success = overlay.addContour(points: [0, 0, 1], shapeType: .subject)
    assert(success == false)
}

@Test func testFloatOverlayWithCGPoint() {
    let overlay = FloatOverlay()
    overlay.addSubject([[
        [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 4),
            CGPoint(x: 4, y: 4),
            CGPoint(x: 4, y: 0),
        ],
    ]])
    overlay.addClip([[
        [
            CGPoint(x: 2, y: 0),
            CGPoint(x: 2, y: 4),
            CGPoint(x: 6, y: 4),
            CGPoint(x: 6, y: 0),
        ],
    ]])

    let result = overlay.overlay(overlayRule: .union, fillRule: .evenOdd)
    assert(result != nil)

    let shapes = result!
    assert(shapes.count == 1)
    assert(shapes[0].count == 1)
    assert(shapes[0][0].count >= 4)
}

@Test func testFloatOverlayFlatBufferReuse() {
    let buffer = FlatF64ShapesBuffer()
    let overlay = FloatOverlay()
    overlay.addSubject([[
        [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 2),
            CGPoint(x: 2, y: 2),
            CGPoint(x: 2, y: 0),
        ],
    ]])

    assert(overlay.overlay(
        overlayRule: .subject,
        fillRule: .nonZero,
        output: buffer
    ))
    assert(buffer.shapeCount == 1)
    assert(buffer.contourCount == 1)
    assert(buffer.pointCount == 8)

    let emptyOverlay = FloatOverlay()
    assert(emptyOverlay.overlay(
        overlayRule: .subject,
        fillRule: .evenOdd,
        output: buffer
    ))
    assert(buffer.shapeCount == 0)
    assert(buffer.contourCount == 0)
    assert(buffer.pointCount == 0)
}

@Test func testCGPathBufferingExpandsRectangle() {
    let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
    let source = CGPath(rect: rect, transform: nil)

    let buffered = CGPathBuffering.offsetPath(path: source, distance: 2)
    assert(buffered != nil)

    let bounds = buffered!.boundingBoxOfPath
    assert(approx(bounds.minX, -2))
    assert(approx(bounds.minY, -2))
    assert(approx(bounds.maxX, 12))
    assert(approx(bounds.maxY, 12))
}

@Test func testCGPathBufferingRejectsNegativeDistance() {
    let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
    let source = CGPath(rect: rect, transform: nil)

    let buffered = CGPathBuffering.offsetPath(path: source, distance: -1)
    assert(buffered == nil)
}

@Test func testCGPathBufferingRejectsBezierCurves() {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addCurve(
        to: CGPoint(x: 10, y: 0),
        control1: CGPoint(x: 2, y: 8),
        control2: CGPoint(x: 8, y: 8)
    )
    path.closeSubpath()

    let buffered = CGPathBuffering.offsetPath(path: path, distance: 1)
    assert(buffered == nil)
}

@Test func testCGPointStrokeOffsetClosedContour() {
    let points: [CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 10, y: 0),
        CGPoint(x: 10, y: 10),
        CGPoint(x: 0, y: 10),
    ]

    let buffered = CGPointStrokeOffset.offsetPath(
        points: points,
        distance: 2,
        isClosedPath: true
    )
    assert(buffered != nil)

    let bounds = buffered!.boundingBoxOfPath
    assert(approx(bounds.minX, -2))
    assert(approx(bounds.minY, -2))
    assert(approx(bounds.maxX, 12))
    assert(approx(bounds.maxY, 12))
}

@Test func testCGPointStrokeOffsetOpenPolyline() {
    let points: [CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 10, y: 0),
    ]

    let shapes = CGPointStrokeOffset.offsetContours(
        points: points,
        distance: 1,
        isClosedPath: false
    )
    assert(shapes != nil)
    assert(!shapes!.isEmpty)
}

@Test func testCGPointStrokeOffsetLineCapButtVsSquare() {
    let points: [CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 10, y: 0),
    ]

    let buttPath = CGPointStrokeOffset.offsetPath(
        points: points,
        distance: 1,
        isClosedPath: false,
        style: StrokeOffsetStyle(lineJoin: .bevel, lineCap: .butt)
    )
    let squarePath = CGPointStrokeOffset.offsetPath(
        points: points,
        distance: 1,
        isClosedPath: false,
        style: StrokeOffsetStyle(lineJoin: .bevel, lineCap: .square)
    )

    assert(buttPath != nil)
    assert(squarePath != nil)

    let buttBounds = buttPath!.boundingBoxOfPath
    let squareBounds = squarePath!.boundingBoxOfPath

    assert(approx(buttBounds.minX, 0))
    assert(approx(buttBounds.maxX, 10))
    assert(approx(squareBounds.minX, -1))
    assert(approx(squareBounds.maxX, 11))
}

@Test func testCGPointStrokeOffsetSupportsRoundJoinAndRoundCap() {
    let points: [CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 10, y: 0),
        CGPoint(x: 10, y: 10),
    ]

    let style = StrokeOffsetStyle(
        lineJoin: .round(0.2),
        startCap: .round(0.2),
        endCap: .round(0.2)
    )

    let shapes = CGPointStrokeOffset.offsetContours(
        points: points,
        distance: 1,
        isClosedPath: false,
        style: style
    )
    assert(shapes != nil)
    assert(!shapes!.isEmpty)
}

@Test func testCGPointStrokeOffsetRejectsNegativeDistance() {
    let points: [CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 10, y: 0),
        CGPoint(x: 10, y: 10),
    ]

    let shapes = CGPointStrokeOffset.offsetContours(
        points: points,
        distance: -1,
        isClosedPath: true
    )
    
    assert(shapes == nil)
}

private func approx(_ value: CGFloat, _ expected: CGFloat, eps: CGFloat = 1e-6) -> Bool {
    abs(value - expected) <= eps
}
