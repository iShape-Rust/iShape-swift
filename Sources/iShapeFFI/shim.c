#include "iShapeFFI.h"

FlatShapesHandle ishape_handle_flat_shapes_create(void) {
    return (FlatShapesHandle)ishape_flat_shapes_create();
}

FlatShapesHandle ishape_handle_flat_shapes_with_capacity(size_t points, size_t contours, size_t shapes) {
    return (FlatShapesHandle)ishape_flat_shapes_with_capacity(points, contours, shapes);
}

void ishape_handle_flat_shapes_clear(FlatShapesHandle buffer) {
    ishape_flat_shapes_clear((FlatShapesBufferOpaque*)buffer);
}

void ishape_handle_flat_shapes_free(FlatShapesHandle buffer) {
    ishape_flat_shapes_free((FlatShapesBufferOpaque*)buffer);
}

const int32_t* ishape_handle_flat_shapes_points_ptr(FlatShapesHandle buffer) {
    return ishape_flat_shapes_points_ptr((const FlatShapesBufferOpaque*)buffer);
}

size_t ishape_handle_flat_shapes_points_len(FlatShapesHandle buffer) {
    return ishape_flat_shapes_points_len((const FlatShapesBufferOpaque*)buffer);
}

const RangeFFI* ishape_handle_flat_shapes_contours_ptr(FlatShapesHandle buffer) {
    return ishape_flat_shapes_contours_ptr((const FlatShapesBufferOpaque*)buffer);
}

size_t ishape_handle_flat_shapes_contours_len(FlatShapesHandle buffer) {
    return ishape_flat_shapes_contours_len((const FlatShapesBufferOpaque*)buffer);
}

const RangeFFI* ishape_handle_flat_shapes_shapes_ptr(FlatShapesHandle buffer) {
    return ishape_flat_shapes_shapes_ptr((const FlatShapesBufferOpaque*)buffer);
}

size_t ishape_handle_flat_shapes_shapes_len(FlatShapesHandle buffer) {
    return ishape_flat_shapes_shapes_len((const FlatShapesBufferOpaque*)buffer);
}

IntOverlayHandle ishape_handle_overlay_int_create(size_t capacity, IntOverlayOptions options) {
    return (IntOverlayHandle)ishape_overlay_int_create(capacity, options);
}

void ishape_handle_overlay_int_free(IntOverlayHandle handle) {
    ishape_overlay_int_free((IntOverlayOpaque*)handle);
}

bool ishape_handle_overlay_int_add_contour(IntOverlayHandle handle, const int32_t* points, size_t count, IntShapeType shape_type) {
    return ishape_overlay_int_add_contour((IntOverlayOpaque*)handle, points, count, shape_type);
}

bool ishape_handle_overlay_int_overlay_into_flat(IntOverlayHandle handle, IntOverlayRule overlay_rule, IntFillRule fill_rule, FlatShapesHandle output) {
    return ishape_overlay_int_overlay_into_flat(
        (IntOverlayOpaque*)handle,
        overlay_rule,
        fill_rule,
        (FlatShapesBufferOpaque*)output
    );
}
