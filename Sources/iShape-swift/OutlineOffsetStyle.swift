import CoreGraphics

/// Join settings for closed-shape outline offsets. Angles are in radians.
@frozen
public struct OutlineOffsetStyle: Sendable {
    public var lineJoin: StrokeLineJoin

    /// Miter turns below this angle use bevel joins. Defaults to 5 degrees.
    /// Finite values are clamped to 0...pi; zero disables the cutoff.
    /// Ignored for bevel and round joins.
    public var miterMinTurn: CGFloat

    public init(
        lineJoin: StrokeLineJoin = .bevel,
        miterMinTurn: CGFloat = .pi / 36
    ) {
        self.lineJoin = lineJoin
        self.miterMinTurn = miterMinTurn
    }
}

public extension OutlineOffsetStyle {
    static let `default` = OutlineOffsetStyle()
}
