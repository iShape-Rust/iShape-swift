#ifndef ISHAPE_FFI_H
#define ISHAPE_FFI_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

typedef void FlatShapesBufferOpaque;
typedef void IntOverlayOpaque;

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

typedef struct IntOverlayOptions {
    bool preserve_input_collinear;
    IntContourDirection output_direction;
    bool preserve_output_collinear;
    uint64_t min_output_area;
} IntOverlayOptions;

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

IntOverlayOpaque* ishape_overlay_int_create(size_t capacity, IntOverlayOptions options);
void ishape_overlay_int_free(IntOverlayOpaque* handle);
bool ishape_overlay_int_add_contour(IntOverlayOpaque* handle, const int32_t* points, size_t count, IntShapeType shape_type);
bool ishape_overlay_int_overlay_into_flat(IntOverlayOpaque* handle, IntOverlayRule overlay_rule, IntFillRule fill_rule, FlatShapesBufferOpaque* output);

typedef void* FlatShapesHandle;
typedef void* IntOverlayHandle;

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

IntOverlayHandle ishape_handle_overlay_int_create(size_t capacity, IntOverlayOptions options);
void ishape_handle_overlay_int_free(IntOverlayHandle handle);
bool ishape_handle_overlay_int_add_contour(IntOverlayHandle handle, const int32_t* points, size_t count, IntShapeType shape_type);
bool ishape_handle_overlay_int_overlay_into_flat(IntOverlayHandle handle, IntOverlayRule overlay_rule, IntFillRule fill_rule, FlatShapesHandle output);

#endif /* ISHAPE_FFI_H */
