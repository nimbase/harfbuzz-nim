# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## Bindings for hb-ot-metrics.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_font

export hb_common
export hb_font

type
  hb_ot_metrics_tag_t* {.size: 4.} = enum
    HB_OT_METRICS_TAG_HORIZONTAL_ASCENDER = 0x68617363
    HB_OT_METRICS_TAG_HORIZONTAL_DESCENDER = 0x68647363
    HB_OT_METRICS_TAG_HORIZONTAL_LINE_GAP = 0x686C6770
    HB_OT_METRICS_TAG_HORIZONTAL_CLIPPING_ASCENT = 0x68636C61
    HB_OT_METRICS_TAG_HORIZONTAL_CLIPPING_DESCENT = 0x68636C64
    HB_OT_METRICS_TAG_VERTICAL_ASCENDER = 0x76617363
    HB_OT_METRICS_TAG_VERTICAL_DESCENDER = 0x76647363
    HB_OT_METRICS_TAG_VERTICAL_LINE_GAP = 0x766C6770
    HB_OT_METRICS_TAG_HORIZONTAL_CARET_RISE = 0x68637273
    HB_OT_METRICS_TAG_HORIZONTAL_CARET_RUN = 0x6863726E
    HB_OT_METRICS_TAG_HORIZONTAL_CARET_OFFSET = 0x68636F66
    HB_OT_METRICS_TAG_VERTICAL_CARET_RISE = 0x76637273
    HB_OT_METRICS_TAG_VERTICAL_CARET_RUN = 0x7663726E
    HB_OT_METRICS_TAG_VERTICAL_CARET_OFFSET = 0x76636F66
    HB_OT_METRICS_TAG_X_HEIGHT = 0x78686774
    HB_OT_METRICS_TAG_CAP_HEIGHT = 0x63706874
    HB_OT_METRICS_TAG_SUBSCRIPT_EM_X_SIZE = 0x73627873
    HB_OT_METRICS_TAG_SUBSCRIPT_EM_Y_SIZE = 0x73627973
    HB_OT_METRICS_TAG_SUBSCRIPT_EM_X_OFFSET = 0x7362786F
    HB_OT_METRICS_TAG_SUBSCRIPT_EM_Y_OFFSET = 0x7362796F
    HB_OT_METRICS_TAG_SUPERSCRIPT_EM_X_SIZE = 0x73707873
    HB_OT_METRICS_TAG_SUPERSCRIPT_EM_Y_SIZE = 0x73707973
    HB_OT_METRICS_TAG_SUPERSCRIPT_EM_X_OFFSET = 0x7370786F
    HB_OT_METRICS_TAG_SUPERSCRIPT_EM_Y_OFFSET = 0x7370796F
    HB_OT_METRICS_TAG_STRIKEOUT_SIZE = 0x73747273
    HB_OT_METRICS_TAG_STRIKEOUT_OFFSET = 0x7374726F
    HB_OT_METRICS_TAG_UNDERLINE_SIZE = 0x756E6473
    HB_OT_METRICS_TAG_UNDERLINE_OFFSET = 0x756E646F
    HB_OT_METRICS_TAG_MAX_VALUE = 0x7FFFFFFF

{.push header: "<harfbuzz/hb-ot.h>", importc, cdecl.}

proc hb_ot_metrics_get_position*(font: ptr hb_font_t;
                                 metrics_tag: hb_ot_metrics_tag_t;
                                 position: ptr hb_position_t): hb_bool_t
proc hb_ot_metrics_get_position_with_fallback*(font: ptr hb_font_t;
                                               metrics_tag: hb_ot_metrics_tag_t;
                                               position: ptr hb_position_t)
proc hb_ot_metrics_get_variation*(font: ptr hb_font_t;
                                  metrics_tag: hb_ot_metrics_tag_t): cfloat
proc hb_ot_metrics_get_x_variation*(font: ptr hb_font_t;
                                    metrics_tag: hb_ot_metrics_tag_t): hb_position_t
proc hb_ot_metrics_get_y_variation*(font: ptr hb_font_t;
                                    metrics_tag: hb_ot_metrics_tag_t): hb_position_t

{.pop.}
