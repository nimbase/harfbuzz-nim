## Bindings for hb-font.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_face
import harfbuzz/hb_draw
import harfbuzz/hb_paint

export hb_common
export hb_face
export hb_draw
export hb_paint

type
  hb_font_funcs_t* = object

  hb_font_extents_t* = object
    ascender*: hb_position_t
    descender*: hb_position_t
    line_gap*: hb_position_t
    reserved9*: hb_position_t
    reserved8*: hb_position_t
    reserved7*: hb_position_t
    reserved6*: hb_position_t
    reserved5*: hb_position_t
    reserved4*: hb_position_t
    reserved3*: hb_position_t
    reserved2*: hb_position_t
    reserved1*: hb_position_t

  hb_font_get_font_extents_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer;
         extents: ptr hb_font_extents_t;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_font_get_font_h_extents_func_t* = hb_font_get_font_extents_func_t
  hb_font_get_font_v_extents_func_t* = hb_font_get_font_extents_func_t

  hb_font_get_nominal_glyph_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; unicode: hb_codepoint_t;
         glyph: ptr hb_codepoint_t;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_font_get_variation_glyph_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; unicode: hb_codepoint_t;
         variation_selector: hb_codepoint_t; glyph: ptr hb_codepoint_t;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_font_get_nominal_glyphs_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; count: cuint;
         first_unicode: ptr hb_codepoint_t; unicode_stride: cuint;
         first_glyph: ptr hb_codepoint_t; glyph_stride: cuint;
         user_data: pointer): cuint {.cdecl.}

  hb_font_get_glyph_advance_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; glyph: hb_codepoint_t;
         user_data: pointer): hb_position_t {.cdecl.}

  hb_font_get_glyph_h_advance_func_t* = hb_font_get_glyph_advance_func_t
  hb_font_get_glyph_v_advance_func_t* = hb_font_get_glyph_advance_func_t

  hb_font_get_glyph_advances_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; count: cuint;
         first_glyph: ptr hb_codepoint_t; glyph_stride: cuint;
         first_advance: ptr hb_position_t; advance_stride: cuint;
         user_data: pointer) {.cdecl.}

  hb_font_get_glyph_h_advances_func_t* = hb_font_get_glyph_advances_func_t
  hb_font_get_glyph_v_advances_func_t* = hb_font_get_glyph_advances_func_t

  hb_font_get_glyph_origin_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; glyph: hb_codepoint_t;
         x: ptr hb_position_t; y: ptr hb_position_t;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_font_get_glyph_h_origin_func_t* = hb_font_get_glyph_origin_func_t
  hb_font_get_glyph_v_origin_func_t* = hb_font_get_glyph_origin_func_t

  hb_font_get_glyph_origins_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; count: cuint;
         first_glyph: ptr hb_codepoint_t; glyph_stride: cuint;
         first_x: ptr hb_position_t; x_stride: cuint;
         first_y: ptr hb_position_t; y_stride: cuint;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_font_get_glyph_h_origins_func_t* = hb_font_get_glyph_origins_func_t
  hb_font_get_glyph_v_origins_func_t* = hb_font_get_glyph_origins_func_t

  hb_font_get_glyph_kerning_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer;
         first_glyph: hb_codepoint_t; second_glyph: hb_codepoint_t;
         user_data: pointer): hb_position_t {.cdecl.}

  hb_font_get_glyph_h_kerning_func_t* = hb_font_get_glyph_kerning_func_t

  hb_font_get_glyph_extents_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; glyph: hb_codepoint_t;
         extents: ptr hb_glyph_extents_t;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_font_get_glyph_contour_point_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; glyph: hb_codepoint_t;
         point_index: cuint; x: ptr hb_position_t; y: ptr hb_position_t;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_font_get_glyph_name_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; glyph: hb_codepoint_t;
         name: cstring; size: cuint;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_font_get_glyph_from_name_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; name: cstring; len: cint;
         glyph: ptr hb_codepoint_t;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_font_draw_glyph_or_fail_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; glyph: hb_codepoint_t;
         draw_funcs: ptr hb_draw_funcs_t; draw_data: pointer;
         user_data: pointer): hb_bool_t {.cdecl.}

  hb_font_paint_glyph_or_fail_func_t* =
    proc(font: ptr hb_font_t; font_data: pointer; glyph: hb_codepoint_t;
         paint_funcs: ptr hb_paint_funcs_t; paint_data: pointer;
         palette_index: cuint; foreground: hb_color_t;
         user_data: pointer): hb_bool_t {.cdecl.}

const
  HB_FONT_NO_VAR_NAMED_INSTANCE* = 0xFFFFFFFF'u32

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_font_funcs_create*(): ptr hb_font_funcs_t
proc hb_font_funcs_get_empty*(): ptr hb_font_funcs_t
proc hb_font_funcs_reference*(ffuncs: ptr hb_font_funcs_t): ptr hb_font_funcs_t
proc hb_font_funcs_destroy*(ffuncs: ptr hb_font_funcs_t)
proc hb_font_funcs_set_user_data*(ffuncs: ptr hb_font_funcs_t;
                                  key: ptr hb_user_data_key_t; data: pointer;
                                  destroy: hb_destroy_func_t;
                                  replace: hb_bool_t): hb_bool_t
proc hb_font_funcs_get_user_data*(ffuncs: ptr hb_font_funcs_t;
                                  key: ptr hb_user_data_key_t): pointer
proc hb_font_funcs_make_immutable*(ffuncs: ptr hb_font_funcs_t)
proc hb_font_funcs_is_immutable*(ffuncs: ptr hb_font_funcs_t): hb_bool_t
proc hb_font_funcs_set_font_h_extents_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_font_h_extents_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_font_v_extents_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_font_v_extents_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_nominal_glyph_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_nominal_glyph_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_nominal_glyphs_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_nominal_glyphs_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_variation_glyph_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_variation_glyph_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_h_advance_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_h_advance_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_v_advance_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_v_advance_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_h_advances_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_h_advances_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_v_advances_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_v_advances_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_h_origin_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_h_origin_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_v_origin_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_v_origin_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_h_origins_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_h_origins_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_v_origins_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_v_origins_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_h_kerning_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_h_kerning_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_extents_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_extents_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_contour_point_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_contour_point_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_name_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_name_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_glyph_from_name_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_get_glyph_from_name_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_draw_glyph_or_fail_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_draw_glyph_or_fail_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_funcs_set_paint_glyph_or_fail_func*(
    ffuncs: ptr hb_font_funcs_t; `func`: hb_font_paint_glyph_or_fail_func_t;
    user_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_get_h_extents*(font: ptr hb_font_t;
                            extents: ptr hb_font_extents_t): hb_bool_t
proc hb_font_get_v_extents*(font: ptr hb_font_t;
                            extents: ptr hb_font_extents_t): hb_bool_t
proc hb_font_get_nominal_glyph*(font: ptr hb_font_t; unicode: hb_codepoint_t;
                                glyph: ptr hb_codepoint_t): hb_bool_t
proc hb_font_get_variation_glyph*(font: ptr hb_font_t;
                                  unicode: hb_codepoint_t;
                                  variation_selector: hb_codepoint_t;
                                  glyph: ptr hb_codepoint_t): hb_bool_t
proc hb_font_get_nominal_glyphs*(font: ptr hb_font_t; count: cuint;
                                 first_unicode: ptr hb_codepoint_t;
                                 unicode_stride: cuint;
                                 first_glyph: ptr hb_codepoint_t;
                                 glyph_stride: cuint): cuint
proc hb_font_get_glyph_h_advance*(font: ptr hb_font_t;
                                  glyph: hb_codepoint_t): hb_position_t
proc hb_font_get_glyph_v_advance*(font: ptr hb_font_t;
                                  glyph: hb_codepoint_t): hb_position_t
proc hb_font_get_glyph_h_advances*(font: ptr hb_font_t; count: cuint;
                                   first_glyph: ptr hb_codepoint_t;
                                   glyph_stride: cuint;
                                   first_advance: ptr hb_position_t;
                                   advance_stride: cuint)
proc hb_font_get_glyph_v_advances*(font: ptr hb_font_t; count: cuint;
                                   first_glyph: ptr hb_codepoint_t;
                                   glyph_stride: cuint;
                                   first_advance: ptr hb_position_t;
                                   advance_stride: cuint)
proc hb_font_get_glyph_h_origin*(font: ptr hb_font_t;
                                 glyph: hb_codepoint_t;
                                 x: ptr hb_position_t;
                                 y: ptr hb_position_t): hb_bool_t
proc hb_font_get_glyph_v_origin*(font: ptr hb_font_t;
                                 glyph: hb_codepoint_t;
                                 x: ptr hb_position_t;
                                 y: ptr hb_position_t): hb_bool_t
proc hb_font_get_glyph_h_origins*(font: ptr hb_font_t; count: cuint;
                                  first_glyph: ptr hb_codepoint_t;
                                  glyph_stride: cuint;
                                  first_x: ptr hb_position_t; x_stride: cuint;
                                  first_y: ptr hb_position_t;
                                  y_stride: cuint): hb_bool_t
proc hb_font_get_glyph_v_origins*(font: ptr hb_font_t; count: cuint;
                                  first_glyph: ptr hb_codepoint_t;
                                  glyph_stride: cuint;
                                  first_x: ptr hb_position_t; x_stride: cuint;
                                  first_y: ptr hb_position_t;
                                  y_stride: cuint): hb_bool_t
proc hb_font_get_glyph_h_kerning*(font: ptr hb_font_t;
                                  left_glyph: hb_codepoint_t;
                                  right_glyph: hb_codepoint_t): hb_position_t
proc hb_font_get_glyph_extents*(font: ptr hb_font_t; glyph: hb_codepoint_t;
                                extents: ptr hb_glyph_extents_t): hb_bool_t
proc hb_font_get_glyph_contour_point*(font: ptr hb_font_t;
                                      glyph: hb_codepoint_t;
                                      point_index: cuint;
                                      x: ptr hb_position_t;
                                      y: ptr hb_position_t): hb_bool_t
proc hb_font_get_glyph_name*(font: ptr hb_font_t; glyph: hb_codepoint_t;
                             name: cstring; size: cuint): hb_bool_t
proc hb_font_get_glyph_from_name*(font: ptr hb_font_t; name: cstring;
                                  len: cint;
                                  glyph: ptr hb_codepoint_t): hb_bool_t
proc hb_font_draw_glyph_or_fail*(font: ptr hb_font_t; glyph: hb_codepoint_t;
                                 dfuncs: ptr hb_draw_funcs_t;
                                 draw_data: pointer): hb_bool_t
proc hb_font_paint_glyph_or_fail*(font: ptr hb_font_t; glyph: hb_codepoint_t;
                                  pfuncs: ptr hb_paint_funcs_t;
                                  paint_data: pointer; palette_index: cuint;
                                  foreground: hb_color_t): hb_bool_t
proc hb_font_get_glyph*(font: ptr hb_font_t; unicode: hb_codepoint_t;
                        variation_selector: hb_codepoint_t;
                        glyph: ptr hb_codepoint_t): hb_bool_t
proc hb_font_get_extents_for_direction*(font: ptr hb_font_t;
                                        direction: hb_direction_t;
                                        extents: ptr hb_font_extents_t)
proc hb_font_get_glyph_advance_for_direction*(font: ptr hb_font_t;
                                              glyph: hb_codepoint_t;
                                              direction: hb_direction_t;
                                              x: ptr hb_position_t;
                                              y: ptr hb_position_t)
proc hb_font_get_glyph_advances_for_direction*(font: ptr hb_font_t;
                                               direction: hb_direction_t;
                                               count: cuint;
                                               first_glyph: ptr hb_codepoint_t;
                                               glyph_stride: cuint;
                                               first_advance: ptr hb_position_t;
                                               advance_stride: cuint)
proc hb_font_get_glyph_origin_for_direction*(font: ptr hb_font_t;
                                             glyph: hb_codepoint_t;
                                             direction: hb_direction_t;
                                             x: ptr hb_position_t;
                                             y: ptr hb_position_t)
proc hb_font_add_glyph_origin_for_direction*(font: ptr hb_font_t;
                                             glyph: hb_codepoint_t;
                                             direction: hb_direction_t;
                                             x: ptr hb_position_t;
                                             y: ptr hb_position_t)
proc hb_font_subtract_glyph_origin_for_direction*(font: ptr hb_font_t;
                                                  glyph: hb_codepoint_t;
                                                  direction: hb_direction_t;
                                                  x: ptr hb_position_t;
                                                  y: ptr hb_position_t)
proc hb_font_get_glyph_kerning_for_direction*(font: ptr hb_font_t;
                                              first_glyph: hb_codepoint_t;
                                              second_glyph: hb_codepoint_t;
                                              direction: hb_direction_t;
                                              x: ptr hb_position_t;
                                              y: ptr hb_position_t)
proc hb_font_get_glyph_extents_for_origin*(font: ptr hb_font_t;
                                           glyph: hb_codepoint_t;
                                           direction: hb_direction_t;
                                           extents: ptr hb_glyph_extents_t): hb_bool_t
proc hb_font_get_glyph_contour_point_for_origin*(font: ptr hb_font_t;
                                                 glyph: hb_codepoint_t;
                                                 point_index: cuint;
                                                 direction: hb_direction_t;
                                                 x: ptr hb_position_t;
                                                 y: ptr hb_position_t): hb_bool_t
proc hb_font_glyph_to_string*(font: ptr hb_font_t; glyph: hb_codepoint_t;
                              s: cstring; size: cuint)
proc hb_font_glyph_from_string*(font: ptr hb_font_t; s: cstring; len: cint;
                                glyph: ptr hb_codepoint_t): hb_bool_t
proc hb_font_draw_glyph*(font: ptr hb_font_t; glyph: hb_codepoint_t;
                         dfuncs: ptr hb_draw_funcs_t; draw_data: pointer)
proc hb_font_paint_glyph*(font: ptr hb_font_t; glyph: hb_codepoint_t;
                          pfuncs: ptr hb_paint_funcs_t; paint_data: pointer;
                          palette_index: cuint; foreground: hb_color_t)
proc hb_font_create*(face: ptr hb_face_t): ptr hb_font_t
proc hb_font_create_sub_font*(parent: ptr hb_font_t): ptr hb_font_t
proc hb_font_get_empty*(): ptr hb_font_t
proc hb_font_reference*(font: ptr hb_font_t): ptr hb_font_t
proc hb_font_destroy*(font: ptr hb_font_t)
proc hb_font_set_user_data*(font: ptr hb_font_t;
                            key: ptr hb_user_data_key_t; data: pointer;
                            destroy: hb_destroy_func_t;
                            replace: hb_bool_t): hb_bool_t
proc hb_font_get_user_data*(font: ptr hb_font_t;
                            key: ptr hb_user_data_key_t): pointer
proc hb_font_make_immutable*(font: ptr hb_font_t)
proc hb_font_is_immutable*(font: ptr hb_font_t): hb_bool_t
proc hb_font_get_serial*(font: ptr hb_font_t): cuint
proc hb_font_changed*(font: ptr hb_font_t)
proc hb_font_set_parent*(font: ptr hb_font_t; parent: ptr hb_font_t)
proc hb_font_get_parent*(font: ptr hb_font_t): ptr hb_font_t
proc hb_font_set_face*(font: ptr hb_font_t; face: ptr hb_face_t)
proc hb_font_get_face*(font: ptr hb_font_t): ptr hb_face_t
proc hb_font_set_funcs*(font: ptr hb_font_t; klass: ptr hb_font_funcs_t;
                        font_data: pointer; destroy: hb_destroy_func_t)
proc hb_font_set_funcs_data*(font: ptr hb_font_t; font_data: pointer;
                             destroy: hb_destroy_func_t)
proc hb_font_set_funcs_using*(font: ptr hb_font_t;
                              name: cstring): hb_bool_t
proc hb_font_list_funcs*(): ptr cstring
proc hb_font_set_scale*(font: ptr hb_font_t; x_scale: cint; y_scale: cint)
proc hb_font_get_scale*(font: ptr hb_font_t; x_scale: ptr cint;
                        y_scale: ptr cint)
proc hb_font_set_ppem*(font: ptr hb_font_t; x_ppem: cuint; y_ppem: cuint)
proc hb_font_get_ppem*(font: ptr hb_font_t; x_ppem: ptr cuint;
                       y_ppem: ptr cuint)
proc hb_font_set_ptem*(font: ptr hb_font_t; ptem: cfloat)
proc hb_font_get_ptem*(font: ptr hb_font_t): cfloat
proc hb_font_is_synthetic*(font: ptr hb_font_t): hb_bool_t
proc hb_font_set_synthetic_bold*(font: ptr hb_font_t; x_embolden: cfloat;
                                 y_embolden: cfloat; in_place: hb_bool_t)
proc hb_font_get_synthetic_bold*(font: ptr hb_font_t; x_embolden: ptr cfloat;
                                 y_embolden: ptr cfloat;
                                 in_place: ptr hb_bool_t)
proc hb_font_set_synthetic_slant*(font: ptr hb_font_t; slant: cfloat)
proc hb_font_get_synthetic_slant*(font: ptr hb_font_t): cfloat
proc hb_font_set_variations*(font: ptr hb_font_t;
                             variations: ptr hb_variation_t;
                             variations_length: cuint)
proc hb_font_set_variation*(font: ptr hb_font_t; tag: hb_tag_t;
                            value: cfloat)
proc hb_font_set_var_coords_design*(font: ptr hb_font_t; coords: ptr cfloat;
                                    coords_length: cuint)
proc hb_font_get_var_coords_design*(font: ptr hb_font_t;
                                    length: ptr cuint): ptr cfloat
proc hb_font_set_var_coords_normalized*(font: ptr hb_font_t;
                                        coords: ptr cint;
                                        coords_length: cuint)
proc hb_font_get_var_coords_normalized*(font: ptr hb_font_t;
                                        length: ptr cuint): ptr cint
proc hb_font_set_var_named_instance*(font: ptr hb_font_t;
                                     instance_index: cuint)
proc hb_font_get_var_named_instance*(font: ptr hb_font_t): cuint

{.pop.}
