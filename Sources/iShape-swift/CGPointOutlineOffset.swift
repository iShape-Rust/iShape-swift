import CoreGraphics

public enum CGPointOutlineOffset {
    public static func offsetContours(
        points: [CGPoint],
        distance: CGFloat
    ) -> CGPointShapes? {
        offsetContours(contours: [points], distance: distance)
    }

    public static func offsetContours(
        contours: CGPointShape,
        distance: CGFloat
    ) -> CGPointShapes? {
        let input = FlatF64ShapesBuffer()
        guard input.setShape(contours) else {
            return nil
        }

        return FlatF64ShapeOffset.offsetContours(input: input, distance: distance)
    }

    public static func offsetShape(
        shape: CGPointShape,
        distance: CGFloat
    ) -> CGPointShapes? {
        let input = FlatF64ShapesBuffer()
        guard input.setShape(shape) else {
            return nil
        }

        return FlatF64ShapeOffset.offset(input: input, distance: distance)
    }

    public static func offsetShape(
        contours: CGPointShape,
        distance: CGFloat
    ) -> CGPointShapes? {
        offsetShape(shape: contours, distance: distance)
    }

    public static func offsetShapes(
        shapes: CGPointShapes,
        distance: CGFloat
    ) -> CGPointShapes? {
        let input = FlatF64ShapesBuffer()
        guard input.setShapes(shapes) else {
            return nil
        }

        return FlatF64ShapeOffset.offset(input: input, distance: distance)
    }
}
