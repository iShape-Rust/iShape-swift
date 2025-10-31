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
