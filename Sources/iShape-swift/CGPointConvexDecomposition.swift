import CoreGraphics
import iShapeFFI

public enum CGPointConvexDecomposition {
    /// Groups a Delaunay triangulation of `shapes` into non-overlapping
    /// counter-clockwise convex polygons.
    @discardableResult
    public static func toConvexPolygons(
        input: FlatF64ShapesBuffer,
        output: FlatF64ShapesBuffer
    ) -> Bool {
        ishape_handle_triangle_f64_shapes_to_convex_polygons(
            input.rawPointer,
            output.rawPointer
        )
    }

    /// Groups a Delaunay triangulation of `shapes` into non-overlapping
    /// counter-clockwise convex polygons.
    public static func toConvexPolygons(
        shapes: CGPointShapes
    ) -> [CGPointContour]? {
        let input = FlatF64ShapesBuffer()
        guard input.setShapes(shapes) else {
            return nil
        }

        let output = FlatF64ShapesBuffer()
        guard toConvexPolygons(input: input, output: output) else {
            return nil
        }

        let polygons = output.toCGPointShapes().compactMap { $0.first }
        return polygons.isEmpty ? nil : polygons
    }

    /// Convenience overload for one shape, including shapes with holes.
    public static func toConvexPolygons(
        shape: CGPointShape
    ) -> [CGPointContour]? {
        toConvexPolygons(shapes: [shape])
    }
}
