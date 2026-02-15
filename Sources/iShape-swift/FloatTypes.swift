import CoreGraphics
import iShapeFFI

public typealias CGPointContour = [CGPoint]
public typealias CGPointShape = [CGPointContour]
public typealias CGPointShapes = [CGPointShape]

@frozen
public struct FloatOverlayOptions: Sendable {
    public var preserveInputCollinear: Bool
    public var outputDirection: ContourDirection
    public var preserveOutputCollinear: Bool
    public var minOutputArea: Double
    public var cleanResult: Bool

    @inlinable
    public init(
        preserveInputCollinear: Bool = false,
        outputDirection: ContourDirection = .counterClockwise,
        preserveOutputCollinear: Bool = false,
        minOutputArea: Double = 0,
        cleanResult: Bool = false
    ) {
        self.preserveInputCollinear = preserveInputCollinear
        self.outputDirection = outputDirection
        self.preserveOutputCollinear = preserveOutputCollinear
        self.minOutputArea = minOutputArea
        self.cleanResult = cleanResult
    }

    @inlinable
    internal var ffiValue: iShapeFFI.Float64OverlayOptions {
        iShapeFFI.Float64OverlayOptions(
            preserve_input_collinear: preserveInputCollinear,
            output_direction: outputDirection.ffiValue,
            preserve_output_collinear: preserveOutputCollinear,
            min_output_area: minOutputArea,
            clean_result: cleanResult
        )
    }
}

public extension FloatOverlayOptions {
    static let `default` = FloatOverlayOptions()
}
