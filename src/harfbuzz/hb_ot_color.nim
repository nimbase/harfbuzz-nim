# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## Bindings for hb-ot-color.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_blob
import harfbuzz/hb_face
import harfbuzz/hb_font
import harfbuzz/hb_ot_name

export hb_common
export hb_blob
export hb_face
export hb_font
export hb_ot_name

type
  hb_ot_color_palette_flags_t* {.size: 4.} = enum
    HB_OT_COLOR_PALETTE_FLAG_DEFAULT = 0x00000000
    HB_OT_COLOR_PALETTE_FLAG_USABLE_WITH_LIGHT_BACKGROUND = 0x00000001
    HB_OT_COLOR_PALETTE_FLAG_USABLE_WITH_DARK_BACKGROUND = 0x00000002

  hb_ot_color_layer_t* = object
    glyph*: hb_codepoint_t
    color_index*: cuint

{.push header: "<harfbuzz/hb-ot.h>", importc, cdecl.}

proc hb_ot_color_has_palettes*(face: ptr hb_face_t): hb_bool_t
proc hb_ot_color_palette_get_count*(face: ptr hb_face_t): cuint
proc hb_ot_color_palette_get_name_id*(face: ptr hb_face_t;
                                      palette_index: cuint): hb_ot_name_id_t
proc hb_ot_color_palette_color_get_name_id*(face: ptr hb_face_t;
                                            color_index: cuint): hb_ot_name_id_t
proc hb_ot_color_palette_get_flags*(face: ptr hb_face_t;
                                    palette_index: cuint): hb_ot_color_palette_flags_t
proc hb_ot_color_palette_get_colors*(face: ptr hb_face_t;
                                     palette_index: cuint; start_offset: cuint;
                                     color_count: ptr cuint;
                                     colors: ptr hb_color_t): cuint
proc hb_ot_color_has_layers*(face: ptr hb_face_t): hb_bool_t
proc hb_ot_color_glyph_get_layers*(face: ptr hb_face_t; glyph: hb_codepoint_t;
                                   start_offset: cuint;
                                   layer_count: ptr cuint;
                                   layers: ptr hb_ot_color_layer_t): cuint
proc hb_ot_color_has_paint*(face: ptr hb_face_t): hb_bool_t
proc hb_ot_color_glyph_has_paint*(face: ptr hb_face_t;
                                  glyph: hb_codepoint_t): hb_bool_t
proc hb_ot_color_has_svg*(face: ptr hb_face_t): hb_bool_t
proc hb_ot_color_get_svg_document_count*(face: ptr hb_face_t): cuint
proc hb_ot_color_glyph_get_svg_document_index*(
    face: ptr hb_face_t; glyph: hb_codepoint_t;
    svg_document_index: ptr cuint): hb_bool_t
proc hb_ot_color_get_svg_document_glyph_range*(
    face: ptr hb_face_t; svg_document_index: cuint;
    start_glyph_id: ptr hb_codepoint_t;
    end_glyph_id: ptr hb_codepoint_t): hb_bool_t
proc hb_ot_color_glyph_reference_svg*(face: ptr hb_face_t;
                                      glyph: hb_codepoint_t): ptr hb_blob_t
proc hb_ot_color_has_png*(face: ptr hb_face_t): hb_bool_t
proc hb_ot_color_glyph_reference_png*(font: ptr hb_font_t;
                                      glyph: hb_codepoint_t): ptr hb_blob_t

{.pop.}
