import CoreGraphics
import iShapeFFI

public enum FlatF64ShapeOffset {
    @discardableResult
    public static func offset(
        input: FlatF64ShapesBuffer,
        distance: CGFloat,
        output: FlatF64ShapesBuffer
    ) -> Bool {
        ishape_handle_outline_f64_flat_shapes_to_flat(
            input.rawPointer,
            Double(distance),
            output.rawPointer
        )
    }

    @discardableResult
    public static func offsetContours(
        input: FlatF64ShapesBuffer,
        distance: CGFloat,
        output: FlatF64ShapesBuffer
    ) -> Bool {
        ishape_handle_outline_f64_flat_contours_to_flat(
            input.rawPointer,
            Double(distance),
            output.rawPointer
        )
    }

    public static func offset(
        input: FlatF64ShapesBuffer,
        distance: CGFloat
    ) -> CGPointShapes? {
        let output = FlatF64ShapesBuffer()
        guard offset(input: input, distance: distance, output: output) else {
            return nil
        }

        let shapes = output.toCGPointShapes()
        return shapes.isEmpty ? nil : shapes
    }

    public static func offsetContours(
        input: FlatF64ShapesBuffer,
        distance: CGFloat
    ) -> CGPointShapes? {
        let output = FlatF64ShapesBuffer()
        guard offsetContours(input: input, distance: distance, output: output) else {
            return nil
        }

        let shapes = output.toCGPointShapes()
        return shapes.isEmpty ? nil : shapes
    }
}

public enum FlatF64ShapeBoolean {
    @discardableResult
    public static func overlay(
        subject: FlatF64ShapesBuffer,
        clip: FlatF64ShapesBuffer,
        overlayRule: OverlayRule,
        fillRule: FillRule,
        options: FloatOverlayOptions = .default,
        output: FlatF64ShapesBuffer
    ) -> Bool {
        ishape_handle_overlay_f64_flat_shapes_into_flat(
            subject.rawPointer,
            clip.rawPointer,
            overlayRule.ffiValue,
            fillRule.ffiValue,
            options.ffiValue,
            output.rawPointer
        )
    }

    public static func overlay(
        subject: FlatF64ShapesBuffer,
        clip: FlatF64ShapesBuffer,
        overlayRule: OverlayRule,
        fillRule: FillRule,
        options: FloatOverlayOptions = .default
    ) -> CGPointShapes? {
        let output = FlatF64ShapesBuffer()
        guard overlay(
            subject: subject,
            clip: clip,
            overlayRule: overlayRule,
            fillRule: fillRule,
            options: options,
            output: output
        ) else {
            return nil
        }

        let shapes = output.toCGPointShapes()
        return shapes.isEmpty ? nil : shapes
    }
}
