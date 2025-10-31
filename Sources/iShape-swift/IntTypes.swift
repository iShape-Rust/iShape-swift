import iShapeFFI

@frozen
public struct IntPoint: Equatable, Hashable, Sendable {
    public var x: Int32
    public var y: Int32

    @inlinable
    public init(x: Int32, y: Int32) {
        self.x = x
        self.y = y
    }

    @inlinable
    public init(_ x: Int32, _ y: Int32) {
        self.init(x: x, y: y)
    }
}

public typealias IntContour = [IntPoint]
public typealias IntShape = [IntContour]
public typealias IntShapes = [IntShape]

public enum ShapeType: UInt32, Sendable {
    case subject = 0
    case clip = 1
}

public enum ContourDirection: UInt32, Sendable {
    case counterClockwise = 0
    case clockwise = 1
}

public enum OverlayRule: UInt32, Sendable {
    case subject = 0
    case clip = 1
    case intersect = 2
    case union = 3
    case difference = 4
    case inverseDifference = 5
    case xor = 6
}

public enum FillRule: UInt32, Sendable {
    case evenOdd = 0
    case nonZero = 1
    case positive = 2
    case negative = 3
}

@frozen
public struct IntOverlayOptions: Sendable {
    public var preserveInputCollinear: Bool
    public var outputDirection: ContourDirection
    public var preserveOutputCollinear: Bool
    public var minOutputArea: UInt64

    @inlinable
    public init(
        preserveInputCollinear: Bool = false,
        outputDirection: ContourDirection = .counterClockwise,
        preserveOutputCollinear: Bool = false,
        minOutputArea: UInt64 = 0
    ) {
        self.preserveInputCollinear = preserveInputCollinear
        self.outputDirection = outputDirection
        self.preserveOutputCollinear = preserveOutputCollinear
        self.minOutputArea = minOutputArea
    }

    @inlinable
    internal var ffiValue: iShapeFFI.IntOverlayOptions {
        iShapeFFI.IntOverlayOptions(
            preserve_input_collinear: preserveInputCollinear,
            output_direction: outputDirection.ffiValue,
            preserve_output_collinear: preserveOutputCollinear,
            min_output_area: minOutputArea
        )
    }
}

public extension IntOverlayOptions {
    static let `default` = IntOverlayOptions()

    static let keepAllPoints = IntOverlayOptions(
        preserveInputCollinear: true,
        outputDirection: .counterClockwise,
        preserveOutputCollinear: true,
        minOutputArea: 0
    )

    static let keepOutputPoints = IntOverlayOptions(
        preserveInputCollinear: false,
        outputDirection: .counterClockwise,
        preserveOutputCollinear: true,
        minOutputArea: 0
    )
}

internal extension ShapeType {
    @usableFromInline
    var ffiValue: iShapeFFI.IntShapeType {
        iShapeFFI.IntShapeType(rawValue: rawValue)
    }
}

internal extension ContourDirection {
    @usableFromInline
    var ffiValue: iShapeFFI.IntContourDirection {
        iShapeFFI.IntContourDirection(rawValue: rawValue)
    }
}

internal extension OverlayRule {
    @usableFromInline
    var ffiValue: iShapeFFI.IntOverlayRule {
        iShapeFFI.IntOverlayRule(rawValue: rawValue)
    }
}

internal extension FillRule {
    @usableFromInline
    var ffiValue: iShapeFFI.IntFillRule {
        iShapeFFI.IntFillRule(rawValue: rawValue)
    }
}
