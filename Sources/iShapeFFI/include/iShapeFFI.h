#ifndef ISHAPE_FFI_H
#define ISHAPE_FFI_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

typedef void FlatShapesBufferOpaque;
typedef void FlatF64ShapesBufferOpaque;
typedef void IntOverlayOpaque;
typedef void F64OverlayOpaque;

typedef struct RangeFFI {
    uint64_t start;
    uint64_t end;
} RangeFFI;

typedef enum IntShapeType {
    IntShapeTypeSubject = 0,
    IntShapeTypeClip = 1,
} IntShapeType;

typedef enum IntContourDirection {
    IntContourDirectionCounterClockwise = 0,
    IntContourDirectionClockwise = 1,
} IntContourDirection;

typedef enum IntOverlayRule {
    IntOverlayRuleSubject = 0,
    IntOverlayRuleClip = 1,
    IntOverlayRuleIntersect = 2,
    IntOverlayRuleUnion = 3,
    IntOverlayRuleDifference = 4,
    IntOverlayRuleInverseDifference = 5,
    IntOverlayRuleXor = 6,
} IntOverlayRule;

typedef enum IntFillRule {
    IntFillRuleEvenOdd = 0,
    IntFillRuleNonZero = 1,
    IntFillRulePositive = 2,
    IntFillRuleNegative = 3,
} IntFillRule;

typedef enum StrokeLineJoinKind {
    StrokeLineJoinKindBevel = 0,
    StrokeLineJoinKindMiter = 1,
    StrokeLineJoinKindRound = 2,
} StrokeLineJoinKind;

typedef enum StrokeLineCapKind {
    StrokeLineCapKindButt = 0,
    StrokeLineCapKindRound = 1,
    StrokeLineCapKindSquare = 2,
} StrokeLineCapKind;

typedef struct IntOverlayOptions {
    bool preserve_input_collinear;
    IntContourDirection output_direction;
    bool preserve_output_collinear;
    uint64_t min_output_area;
} IntOverlayOptions;

typedef struct Float64OverlayOptions {
    bool preserve_input_collinear;
    IntContourDirection output_direction;
    bool preserve_output_collinear;
    double min_output_area;
    bool clean_result;
} Float64OverlayOptions;

FlatShapesBufferOpaque* ishape_flat_shapes_create(void);
FlatShapesBufferOpaque* ishape_flat_shapes_with_capacity(size_t points, size_t contours, size_t shapes);
void ishape_flat_shapes_clear(FlatShapesBufferOpaque* buffer);
void ishape_flat_shapes_free(FlatShapesBufferOpaque* buffer);

const int32_t* ishape_flat_shapes_points_ptr(const FlatShapesBufferOpaque* buffer);
size_t ishape_flat_shapes_points_len(const FlatShapesBufferOpaque* buffer);
const RangeFFI* ishape_flat_shapes_contours_ptr(const FlatShapesBufferOpaque* buffer);
size_t ishape_flat_shapes_contours_len(const FlatShapesBufferOpaque* buffer);
const RangeFFI* ishape_flat_shapes_shapes_ptr(const FlatShapesBufferOpaque* buffer);
size_t ishape_flat_shapes_shapes_len(const FlatShapesBufferOpaque* buffer);

FlatF64ShapesBufferOpaque* ishape_flat_f64_shapes_create(void);
FlatF64ShapesBufferOpaque* ishape_flat_f64_shapes_with_capacity(size_t points, size_t contours, size_t shapes);
void ishape_flat_f64_shapes_clear(FlatF64ShapesBufferOpaque* buffer);
void ishape_flat_f64_shapes_free(FlatF64ShapesBufferOpaque* buffer);

const double* ishape_flat_f64_shapes_points_ptr(const FlatF64ShapesBufferOpaque* buffer);
size_t ishape_flat_f64_shapes_points_len(const FlatF64ShapesBufferOpaque* buffer);
const RangeFFI* ishape_flat_f64_shapes_contours_ptr(const FlatF64ShapesBufferOpaque* buffer);
size_t ishape_flat_f64_shapes_contours_len(const FlatF64ShapesBufferOpaque* buffer);
const RangeFFI* ishape_flat_f64_shapes_shapes_ptr(const FlatF64ShapesBufferOpaque* buffer);
size_t ishape_flat_f64_shapes_shapes_len(const FlatF64ShapesBufferOpaque* buffer);

IntOverlayOpaque* ishape_overlay_int_create(size_t capacity, IntOverlayOptions options);
void ishape_overlay_int_free(IntOverlayOpaque* handle);
bool ishape_overlay_int_add_contour(IntOverlayOpaque* handle, const int32_t* points, size_t count, IntShapeType shape_type);
bool ishape_overlay_int_overlay_into_flat(IntOverlayOpaque* handle, IntOverlayRule overlay_rule, IntFillRule fill_rule, FlatShapesBufferOpaque* output);

F64OverlayOpaque* ishape_overlay_f64_create(size_t capacity, Float64OverlayOptions options);
void ishape_overlay_f64_free(F64OverlayOpaque* handle);
bool ishape_overlay_f64_add_contour(F64OverlayOpaque* handle, const double* points, size_t count, IntShapeType shape_type);
bool ishape_overlay_f64_overlay_into_flat(F64OverlayOpaque* handle, IntOverlayRule overlay_rule, IntFillRule fill_rule, FlatF64ShapesBufferOpaque* output);
bool ishape_outline_f64_contour_to_flat(const double* points, size_t count, double offset, FlatF64ShapesBufferOpaque* output);
bool ishape_stroke_f64_contour_to_flat_styled(
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
    FlatF64ShapesBufferOpaque* output
);

typedef void* FlatShapesHandle;
typedef void* FlatF64ShapesHandle;
typedef void* IntOverlayHandle;
typedef void* F64OverlayHandle;

FlatShapesHandle ishape_handle_flat_shapes_create(void);
FlatShapesHandle ishape_handle_flat_shapes_with_capacity(size_t points, size_t contours, size_t shapes);
void ishape_handle_flat_shapes_clear(FlatShapesHandle buffer);
void ishape_handle_flat_shapes_free(FlatShapesHandle buffer);

const int32_t* ishape_handle_flat_shapes_points_ptr(FlatShapesHandle buffer);
size_t ishape_handle_flat_shapes_points_len(FlatShapesHandle buffer);
const RangeFFI* ishape_handle_flat_shapes_contours_ptr(FlatShapesHandle buffer);
size_t ishape_handle_flat_shapes_contours_len(FlatShapesHandle buffer);
const RangeFFI* ishape_handle_flat_shapes_shapes_ptr(FlatShapesHandle buffer);
size_t ishape_handle_flat_shapes_shapes_len(FlatShapesHandle buffer);

FlatF64ShapesHandle ishape_handle_flat_f64_shapes_create(void);
FlatF64ShapesHandle ishape_handle_flat_f64_shapes_with_capacity(size_t points, size_t contours, size_t shapes);
void ishape_handle_flat_f64_shapes_clear(FlatF64ShapesHandle buffer);
void ishape_handle_flat_f64_shapes_free(FlatF64ShapesHandle buffer);

const double* ishape_handle_flat_f64_shapes_points_ptr(FlatF64ShapesHandle buffer);
size_t ishape_handle_flat_f64_shapes_points_len(FlatF64ShapesHandle buffer);
const RangeFFI* ishape_handle_flat_f64_shapes_contours_ptr(FlatF64ShapesHandle buffer);
size_t ishape_handle_flat_f64_shapes_contours_len(FlatF64ShapesHandle buffer);
const RangeFFI* ishape_handle_flat_f64_shapes_shapes_ptr(FlatF64ShapesHandle buffer);
size_t ishape_handle_flat_f64_shapes_shapes_len(FlatF64ShapesHandle buffer);

IntOverlayHandle ishape_handle_overlay_int_create(size_t capacity, IntOverlayOptions options);
void ishape_handle_overlay_int_free(IntOverlayHandle handle);
bool ishape_handle_overlay_int_add_contour(IntOverlayHandle handle, const int32_t* points, size_t count, IntShapeType shape_type);
bool ishape_handle_overlay_int_overlay_into_flat(IntOverlayHandle handle, IntOverlayRule overlay_rule, IntFillRule fill_rule, FlatShapesHandle output);

F64OverlayHandle ishape_handle_overlay_f64_create(size_t capacity, Float64OverlayOptions options);
void ishape_handle_overlay_f64_free(F64OverlayHandle handle);
bool ishape_handle_overlay_f64_add_contour(F64OverlayHandle handle, const double* points, size_t count, IntShapeType shape_type);
bool ishape_handle_overlay_f64_overlay_into_flat(F64OverlayHandle handle, IntOverlayRule overlay_rule, IntFillRule fill_rule, FlatF64ShapesHandle output);
bool ishape_handle_outline_f64_contour_to_flat(const double* points, size_t count, double offset, FlatF64ShapesHandle output);
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
);

#endif /* ISHAPE_FFI_H */
