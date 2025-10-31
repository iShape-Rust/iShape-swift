import iShapeFFI

@usableFromInline
internal func toIndex(_ value: UInt64) -> Int {
    precondition(value <= UInt64(Int.max), "Range value exceeds Int.max")
    return Int(value)
}

extension RangeFFI {
    @inlinable
    var lowerBoundIndex: Int {
        toIndex(start)
    }

    @inlinable
    var upperBoundIndex: Int {
        toIndex(end)
    }
}
