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

FlatF64ShapesHandle ishape_handle_flat_f64_shapes_create(void) {
    return (FlatF64ShapesHandle)ishape_flat_f64_shapes_create();
}

FlatF64ShapesHandle ishape_handle_flat_f64_shapes_with_capacity(size_t points, size_t contours, size_t shapes) {
    return (FlatF64ShapesHandle)ishape_flat_f64_shapes_with_capacity(points, contours, shapes);
}

void ishape_handle_flat_f64_shapes_clear(FlatF64ShapesHandle buffer) {
    ishape_flat_f64_shapes_clear((FlatF64ShapesBufferOpaque*)buffer);
}

void ishape_handle_flat_f64_shapes_free(FlatF64ShapesHandle buffer) {
    ishape_flat_f64_shapes_free((FlatF64ShapesBufferOpaque*)buffer);
}

const double* ishape_handle_flat_f64_shapes_points_ptr(FlatF64ShapesHandle buffer) {
    return ishape_flat_f64_shapes_points_ptr((const FlatF64ShapesBufferOpaque*)buffer);
}

size_t ishape_handle_flat_f64_shapes_points_len(FlatF64ShapesHandle buffer) {
    return ishape_flat_f64_shapes_points_len((const FlatF64ShapesBufferOpaque*)buffer);
}

const RangeFFI* ishape_handle_flat_f64_shapes_contours_ptr(FlatF64ShapesHandle buffer) {
    return ishape_flat_f64_shapes_contours_ptr((const FlatF64ShapesBufferOpaque*)buffer);
}

size_t ishape_handle_flat_f64_shapes_contours_len(FlatF64ShapesHandle buffer) {
    return ishape_flat_f64_shapes_contours_len((const FlatF64ShapesBufferOpaque*)buffer);
}

const RangeFFI* ishape_handle_flat_f64_shapes_shapes_ptr(FlatF64ShapesHandle buffer) {
    return ishape_flat_f64_shapes_shapes_ptr((const FlatF64ShapesBufferOpaque*)buffer);
}

size_t ishape_handle_flat_f64_shapes_shapes_len(FlatF64ShapesHandle buffer) {
    return ishape_flat_f64_shapes_shapes_len((const FlatF64ShapesBufferOpaque*)buffer);
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

F64OverlayHandle ishape_handle_overlay_f64_create(size_t capacity, Float64OverlayOptions options) {
    return (F64OverlayHandle)ishape_overlay_f64_create(capacity, options);
}

void ishape_handle_overlay_f64_free(F64OverlayHandle handle) {
    ishape_overlay_f64_free((F64OverlayOpaque*)handle);
}

bool ishape_handle_overlay_f64_add_contour(F64OverlayHandle handle, const double* points, size_t count, IntShapeType shape_type) {
    return ishape_overlay_f64_add_contour((F64OverlayOpaque*)handle, points, count, shape_type);
}

bool ishape_handle_overlay_f64_overlay_into_flat(F64OverlayHandle handle, IntOverlayRule overlay_rule, IntFillRule fill_rule, FlatF64ShapesHandle output) {
    return ishape_overlay_f64_overlay_into_flat(
        (F64OverlayOpaque*)handle,
        overlay_rule,
        fill_rule,
        (FlatF64ShapesBufferOpaque*)output
    );
}

bool ishape_handle_outline_f64_contour_to_flat(const double* points, size_t count, double offset, FlatF64ShapesHandle output) {
    return ishape_outline_f64_contour_to_flat(
        points,
        count,
        offset,
        (FlatF64ShapesBufferOpaque*)output
    );
}

bool ishape_handle_stroke_f64_contour_to_flat_styled(
    const double* points,
    size_t count,
    double width,
    bool is_closed_path,
    uint32_t join_kind,
    double join_value,
    uint32_t start_cap_kind,
    double start_cap_value,
    uint32_t end_cap_kind,
    double end_cap_value,
    FlatF64ShapesHandle output
) {
    return ishape_stroke_f64_contour_to_flat_styled(
        points,
        count,
        width,
        is_closed_path,
        join_kind,
        join_value,
        start_cap_kind,
        start_cap_value,
        end_cap_kind,
        end_cap_value,
        (FlatF64ShapesBufferOpaque*)output
    );
}
