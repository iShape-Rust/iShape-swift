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
        let validContours = contours.filter { $0.count >= 3 }
        guard !validContours.isEmpty else {
            return nil
        }

        let input = FlatF64ShapesBuffer()
        guard input.setShape(validContours) else {
            return nil
        }

        return FlatF64ShapeOffset.offsetContours(input: input, distance: distance)
    }

    public static func offsetShape(
        contours: CGPointShape,
        distance: CGFloat
    ) -> CGPointShapes? {
        let validContours = contours.filter { $0.count >= 3 }
        guard !validContours.isEmpty else {
            return nil
        }

        let input = FlatF64ShapesBuffer()
        guard input.setShape(validContours) else {
            return nil
        }

        return FlatF64ShapeOffset.offset(input: input, distance: distance)
    }
}
