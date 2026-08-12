import CoreGraphics
import iShapeFFI

@frozen
public struct ShapeHierarchyLink: Sendable, Equatable {
    public let parentShapeIndex: Int
    public let parentContourIndex: Int
    public let childShapeIndex: Int

    @inlinable
    public init(
        parentShapeIndex: Int,
        parentContourIndex: Int,
        childShapeIndex: Int
    ) {
        self.parentShapeIndex = parentShapeIndex
        self.parentContourIndex = parentContourIndex
        self.childShapeIndex = childShapeIndex
    }
}

@frozen
public struct CGPointShapeHierarchy: Sendable {
    public let shapes: CGPointShapes
    public let links: [ShapeHierarchyLink]

    @inlinable
    public init(shapes: CGPointShapes, links: [ShapeHierarchyLink]) {
        self.shapes = shapes
        self.links = links
    }
}

@usableFromInline
typealias FloatFlatShapeHierarchyHandle = UnsafeMutableRawPointer

@usableFromInline
final class FloatFlatShapeHierarchyBuffer {
    @usableFromInline
    let handle: FloatFlatShapeHierarchyHandle

    @usableFromInline
    init() {
        guard let handle = ishape_handle_float_flat_shape_hierarchy_create() else {
            fatalError("Failed to allocate FloatFlatShapeHierarchyBuffer")
        }
        self.handle = handle
    }

    deinit {
        ishape_handle_float_flat_shape_hierarchy_free(handle)
    }

    @usableFromInline
    func toCGPointShapeHierarchy() -> CGPointShapeHierarchy {
        let shapes: CGPointShapes
        if let shapesHandle = ishape_handle_float_flat_shape_hierarchy_shapes(handle) {
            shapes = FlatF64ShapesBuffer.decodeCGPointShapes(handle: shapesHandle)
        } else {
            shapes = []
        }

        let linkCount = Int(ishape_handle_float_flat_shape_hierarchy_links_len(handle))
        let links: [ShapeHierarchyLink]
        if linkCount > 0,
           let pointer = ishape_handle_float_flat_shape_hierarchy_links_ptr(handle) {
            links = UnsafeBufferPointer(start: pointer, count: linkCount).map { link in
                ShapeHierarchyLink(
                    parentShapeIndex: Int(link.parent_shape_index),
                    parentContourIndex: Int(link.parent_contour_index),
                    childShapeIndex: Int(link.child_shape_index)
                )
            }
        } else {
            links = []
        }

        return CGPointShapeHierarchy(shapes: shapes, links: links)
    }
}
