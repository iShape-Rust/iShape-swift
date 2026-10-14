import CoreGraphics

public enum CGPointOutlineOffset {
    public static func offsetContours(
        points: [CGPoint],
        distance: CGFloat,
        style: OutlineOffsetStyle = .default
    ) -> CGPointShapes? {
        offsetContours(contours: [points], distance: distance, style: style)
    }

    public static func offsetContours(
        contours: CGPointShape,
        distance: CGFloat,
        style: OutlineOffsetStyle = .default
    ) -> CGPointShapes? {
        let input = FlatF64ShapesBuffer()
        guard input.setShape(contours) else {
            return nil
        }

        return FlatF64ShapeOffset.offsetContours(input: input, distance: distance, style: style)
    }

    public static func offsetShape(
        shape: CGPointShape,
        distance: CGFloat,
        style: OutlineOffsetStyle = .default
    ) -> CGPointShapes? {
        let input = FlatF64ShapesBuffer()
        guard input.setShape(shape) else {
            return nil
        }

        return FlatF64ShapeOffset.offset(input: input, distance: distance, style: style)
    }

    public static func offsetShape(
        contours: CGPointShape,
        distance: CGFloat,
        style: OutlineOffsetStyle = .default
    ) -> CGPointShapes? {
        offsetShape(shape: contours, distance: distance, style: style)
    }

    public static func offsetShapes(
        shapes: CGPointShapes,
        distance: CGFloat,
        style: OutlineOffsetStyle = .default
    ) -> CGPointShapes? {
        let input = FlatF64ShapesBuffer()
        guard input.setShapes(shapes) else {
            return nil
        }

        return FlatF64ShapeOffset.offset(input: input, distance: distance, style: style)
    }
}
