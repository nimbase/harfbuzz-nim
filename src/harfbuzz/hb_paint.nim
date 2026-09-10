## Bindings for hb-paint.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_blob
import harfbuzz/hb_draw

export hb_common
export hb_blob
export hb_draw

type
  hb_paint_funcs_t* = object

  hb_paint_push_transform_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer; xx: cfloat;
         yx: cfloat; xy: cfloat; yy: cfloat; dx: cfloat; dy: cfloat;
         user_data: pointer) {.cdecl.}

  hb_paint_pop_transform_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         user_data: pointer) {.cdecl.}

  hb_paint_color_glyph_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         glyph: hb_codepoint_t; font: ptr hb_font_t;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_paint_push_clip_glyph_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         glyph: hb_codepoint_t; font: ptr hb_font_t;
         user_data: pointer) {.cdecl.}

  hb_paint_push_clip_rectangle_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer; xmin: cfloat;
         ymin: cfloat; xmax: cfloat; ymax: cfloat;
         user_data: pointer) {.cdecl.}

  hb_paint_push_clip_path_start_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         draw_data: ptr pointer;
         user_data: pointer): ptr hb_draw_funcs_t {.cdecl.}

  hb_paint_push_clip_path_end_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         user_data: pointer) {.cdecl.}

  hb_paint_pop_clip_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         user_data: pointer) {.cdecl.}

  hb_paint_color_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         is_foreground: hb_bool_t; color: hb_color_t;
         user_data: pointer) {.cdecl.}

  hb_paint_image_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         image: ptr hb_blob_t; width: cuint; height: cuint; format: hb_tag_t;
         slant: cfloat; extents: ptr hb_glyph_extents_t;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_color_stop_t* = object
    offset*: cfloat
    is_foreground*: hb_bool_t
    color*: hb_color_t

  hb_paint_extend_t* {.size: 4.} = enum
    HB_PAINT_EXTEND_PAD = 0
    HB_PAINT_EXTEND_REPEAT = 1
    HB_PAINT_EXTEND_REFLECT = 2

  hb_color_line_t* = object
    data*: pointer
    get_color_stops*: hb_color_line_get_color_stops_func_t
    get_color_stops_user_data*: pointer
    get_extend*: hb_color_line_get_extend_func_t
    get_extend_user_data*: pointer
    reserved0*: pointer
    reserved1*: pointer
    reserved2*: pointer
    reserved3*: pointer
    reserved5*: pointer
    reserved6*: pointer
    reserved7*: pointer
    reserved8*: pointer

  hb_color_line_get_color_stops_func_t* =
    proc(color_line: ptr hb_color_line_t; color_line_data: pointer;
         start: cuint; count: ptr cuint; color_stops: ptr hb_color_stop_t;
         user_data: pointer): cuint {.cdecl.}

  hb_color_line_get_extend_func_t* =
    proc(color_line: ptr hb_color_line_t; color_line_data: pointer;
         user_data: pointer): hb_paint_extend_t {.cdecl.}

  hb_paint_linear_gradient_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         color_line: ptr hb_color_line_t; x0: cfloat; y0: cfloat; x1: cfloat;
         y1: cfloat; x2: cfloat; y2: cfloat;
         user_data: pointer) {.cdecl.}

  hb_paint_radial_gradient_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         color_line: ptr hb_color_line_t; x0: cfloat; y0: cfloat; r0: cfloat;
         x1: cfloat; y1: cfloat; r1: cfloat;
         user_data: pointer) {.cdecl.}

  hb_paint_sweep_gradient_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         color_line: ptr hb_color_line_t; x0: cfloat; y0: cfloat;
         start_angle: cfloat; end_angle: cfloat;
         user_data: pointer) {.cdecl.}

  hb_paint_composite_mode_t* {.size: 4.} = enum
    HB_PAINT_COMPOSITE_MODE_CLEAR = 0
    HB_PAINT_COMPOSITE_MODE_SRC = 1
    HB_PAINT_COMPOSITE_MODE_DEST = 2
    HB_PAINT_COMPOSITE_MODE_SRC_OVER = 3
    HB_PAINT_COMPOSITE_MODE_DEST_OVER = 4
    HB_PAINT_COMPOSITE_MODE_SRC_IN = 5
    HB_PAINT_COMPOSITE_MODE_DEST_IN = 6
    HB_PAINT_COMPOSITE_MODE_SRC_OUT = 7
    HB_PAINT_COMPOSITE_MODE_DEST_OUT = 8
    HB_PAINT_COMPOSITE_MODE_SRC_ATOP = 9
    HB_PAINT_COMPOSITE_MODE_DEST_ATOP = 10
    HB_PAINT_COMPOSITE_MODE_XOR = 11
    HB_PAINT_COMPOSITE_MODE_PLUS = 12
    HB_PAINT_COMPOSITE_MODE_SCREEN = 13
    HB_PAINT_COMPOSITE_MODE_OVERLAY = 14
    HB_PAINT_COMPOSITE_MODE_DARKEN = 15
    HB_PAINT_COMPOSITE_MODE_LIGHTEN = 16
    HB_PAINT_COMPOSITE_MODE_COLOR_DODGE = 17
    HB_PAINT_COMPOSITE_MODE_COLOR_BURN = 18
    HB_PAINT_COMPOSITE_MODE_HARD_LIGHT = 19
    HB_PAINT_COMPOSITE_MODE_SOFT_LIGHT = 20
    HB_PAINT_COMPOSITE_MODE_DIFFERENCE = 21
    HB_PAINT_COMPOSITE_MODE_EXCLUSION = 22
    HB_PAINT_COMPOSITE_MODE_MULTIPLY = 23
    HB_PAINT_COMPOSITE_MODE_HSL_HUE = 24
    HB_PAINT_COMPOSITE_MODE_HSL_SATURATION = 25
    HB_PAINT_COMPOSITE_MODE_HSL_COLOR = 26
    HB_PAINT_COMPOSITE_MODE_HSL_LUMINOSITY = 27

  hb_paint_push_group_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         user_data: pointer) {.cdecl.}

  hb_paint_push_group_for_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         mode: hb_paint_composite_mode_t;
         user_data: pointer) {.cdecl.}

  hb_paint_pop_group_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         mode: hb_paint_composite_mode_t;
         user_data: pointer) {.cdecl.}

  hb_paint_custom_palette_color_func_t* =
    proc(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         color_index: cuint; color: ptr hb_color_t;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_paint_sweep_gradient_tile_func_t* =
    proc(a0: cfloat; c0: hb_color_t; a1: cfloat; c1: hb_color_t;
         user_data: pointer) {.cdecl.}

const
  HB_PAINT_IMAGE_FORMAT_PNG* = hb_tag_t(0x706E6720'u32)
  HB_PAINT_IMAGE_FORMAT_SVG* = hb_tag_t(0x73766720'u32)
  HB_PAINT_IMAGE_FORMAT_BGRA* = hb_tag_t(0x42475241'u32)

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_paint_funcs_create*(): ptr hb_paint_funcs_t
proc hb_paint_funcs_get_empty*(): ptr hb_paint_funcs_t
proc hb_paint_funcs_reference*(funcs: ptr hb_paint_funcs_t): ptr hb_paint_funcs_t
proc hb_paint_funcs_destroy*(funcs: ptr hb_paint_funcs_t)
proc hb_paint_funcs_set_user_data*(funcs: ptr hb_paint_funcs_t;
                                   key: ptr hb_user_data_key_t; data: pointer;
                                   destroy: hb_destroy_func_t;
                                   replace: hb_bool_t): hb_bool_t
proc hb_paint_funcs_get_user_data*(funcs: ptr hb_paint_funcs_t;
                                   key: ptr hb_user_data_key_t): pointer
proc hb_paint_funcs_make_immutable*(funcs: ptr hb_paint_funcs_t)
proc hb_paint_funcs_is_immutable*(funcs: ptr hb_paint_funcs_t): hb_bool_t
proc hb_paint_funcs_set_push_transform_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_push_transform_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_pop_transform_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_pop_transform_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_color_glyph_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_color_glyph_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_push_clip_glyph_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_push_clip_glyph_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_push_clip_rectangle_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_push_clip_rectangle_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_push_clip_path_start_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_push_clip_path_start_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_push_clip_path_end_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_push_clip_path_end_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_pop_clip_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_pop_clip_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_color_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_color_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_image_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_image_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_linear_gradient_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_linear_gradient_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_radial_gradient_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_radial_gradient_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_sweep_gradient_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_sweep_gradient_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_push_group_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_push_group_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_push_group_for_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_push_group_for_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_pop_group_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_pop_group_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_funcs_set_custom_palette_color_func*(
    funcs: ptr hb_paint_funcs_t; `func`: hb_paint_custom_palette_color_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_paint_push_transform*(funcs: ptr hb_paint_funcs_t;
                              paint_data: pointer; xx: cfloat; yx: cfloat;
                              xy: cfloat; yy: cfloat; dx: cfloat; dy: cfloat)
proc hb_paint_push_font_transform*(funcs: ptr hb_paint_funcs_t;
                                   paint_data: pointer; font: ptr hb_font_t)
proc hb_paint_push_inverse_font_transform*(funcs: ptr hb_paint_funcs_t;
                                           paint_data: pointer;
                                           font: ptr hb_font_t)
proc hb_paint_pop_transform*(funcs: ptr hb_paint_funcs_t;
                             paint_data: pointer)
proc hb_paint_color_glyph*(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
                           glyph: hb_codepoint_t;
                           font: ptr hb_font_t): hb_bool_t
proc hb_paint_push_clip_glyph*(funcs: ptr hb_paint_funcs_t;
                               paint_data: pointer; glyph: hb_codepoint_t;
                               font: ptr hb_font_t)
proc hb_paint_push_clip_rectangle*(funcs: ptr hb_paint_funcs_t;
                                   paint_data: pointer; xmin: cfloat;
                                   ymin: cfloat; xmax: cfloat; ymax: cfloat)
proc hb_paint_push_clip_path_start*(funcs: ptr hb_paint_funcs_t;
                                    paint_data: pointer;
                                    draw_data: ptr pointer): ptr hb_draw_funcs_t
proc hb_paint_push_clip_path_end*(funcs: ptr hb_paint_funcs_t;
                                  paint_data: pointer)
proc hb_paint_pop_clip*(funcs: ptr hb_paint_funcs_t; paint_data: pointer)
proc hb_paint_color*(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
                     is_foreground: hb_bool_t; color: hb_color_t)
proc hb_paint_image*(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
                     image: ptr hb_blob_t; width: cuint; height: cuint;
                     format: hb_tag_t; slant: cfloat;
                     extents: ptr hb_glyph_extents_t)
proc hb_paint_linear_gradient*(funcs: ptr hb_paint_funcs_t;
                               paint_data: pointer;
                               color_line: ptr hb_color_line_t; x0: cfloat;
                               y0: cfloat; x1: cfloat; y1: cfloat; x2: cfloat;
                               y2: cfloat)
proc hb_paint_radial_gradient*(funcs: ptr hb_paint_funcs_t;
                               paint_data: pointer;
                               color_line: ptr hb_color_line_t; x0: cfloat;
                               y0: cfloat; r0: cfloat; x1: cfloat; y1: cfloat;
                               r1: cfloat)
proc hb_paint_sweep_gradient*(funcs: ptr hb_paint_funcs_t;
                              paint_data: pointer;
                              color_line: ptr hb_color_line_t; x0: cfloat;
                              y0: cfloat; start_angle: cfloat;
                              end_angle: cfloat)
proc hb_paint_push_group*(funcs: ptr hb_paint_funcs_t; paint_data: pointer)
proc hb_paint_push_group_for*(funcs: ptr hb_paint_funcs_t;
                              paint_data: pointer;
                              mode: hb_paint_composite_mode_t)
proc hb_paint_pop_group*(funcs: ptr hb_paint_funcs_t; paint_data: pointer;
                         mode: hb_paint_composite_mode_t)
proc hb_paint_custom_palette_color*(funcs: ptr hb_paint_funcs_t;
                                    paint_data: pointer; color_index: cuint;
                                    color: ptr hb_color_t): hb_bool_t
proc hb_paint_reduce_linear_anchors*(x0: cfloat; y0: cfloat; x1: cfloat;
                                     y1: cfloat; x2: cfloat; y2: cfloat;
                                     xx0: ptr cfloat; yy0: ptr cfloat;
                                     xx1: ptr cfloat; yy1: ptr cfloat)
proc hb_paint_normalize_color_line*(stops: ptr hb_color_stop_t; len: cuint;
                                    min: ptr cfloat; max: ptr cfloat)
proc hb_paint_sweep_gradient_tiles*(stops: ptr hb_color_stop_t;
                                    n_stops: cuint;
                                    extend: hb_paint_extend_t;
                                    start_angle: cfloat; end_angle: cfloat;
                                    emit_patch: hb_paint_sweep_gradient_tile_func_t;
                                    user_data: pointer)

{.pop.}
