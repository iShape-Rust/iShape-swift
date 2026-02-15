import CoreGraphics
import iShapeFFI

public enum StrokeLineJoin: Sendable {
    case bevel
    case miter(CGFloat)
    case round(CGFloat)

    @usableFromInline
    internal var ffiValue: (kind: UInt32, value: Double) {
        switch self {
        case .bevel:
            return (kind: 0, value: 0)
        case .miter(let ratio):
            return (kind: 1, value: Double(ratio))
        case .round(let ratio):
            return (kind: 2, value: Double(ratio))
        }
    }
}

public enum StrokeLineCap: Sendable {
    case butt
    case round(CGFloat)
    case square

    @usableFromInline
    internal var ffiValue: (kind: UInt32, value: Double) {
        switch self {
        case .butt:
            return (kind: 0, value: 0)
        case .round(let ratio):
            return (kind: 1, value: Double(ratio))
        case .square:
            return (kind: 2, value: 0)
        }
    }
}

@frozen
public struct StrokeOffsetStyle: Sendable {
    public var lineJoin: StrokeLineJoin
    public var startCap: StrokeLineCap
    public var endCap: StrokeLineCap

    public init(
        lineJoin: StrokeLineJoin = .bevel,
        startCap: StrokeLineCap = .butt,
        endCap: StrokeLineCap = .butt
    ) {
        self.lineJoin = lineJoin
        self.startCap = startCap
        self.endCap = endCap
    }

    public init(
        lineJoin: StrokeLineJoin = .bevel,
        lineCap: StrokeLineCap
    ) {
        self.init(lineJoin: lineJoin, startCap: lineCap, endCap: lineCap)
    }
}

public extension StrokeOffsetStyle {
    static let `default` = StrokeOffsetStyle()
}
