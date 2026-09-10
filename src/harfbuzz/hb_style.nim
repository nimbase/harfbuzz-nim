## Bindings for hb-style.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_font

export hb_common
export hb_font

type
  hb_style_tag_t* {.size: 4.} = enum
    HB_STYLE_TAG_ITALIC = 0x6974616C
    HB_STYLE_TAG_OPTICAL_SIZE = 0x6F70737A
    HB_STYLE_TAG_SLANT_ANGLE = 0x736C6E74
    HB_STYLE_TAG_SLANT_RATIO = 0x536C6E74
    HB_STYLE_TAG_WIDTH = 0x77647468
    HB_STYLE_TAG_WEIGHT = 0x77676874
    HB_STYLE_TAG_MAX_VALUE = 0x7FFFFFFF

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_style_get_value*(font: ptr hb_font_t;
                         style_tag: hb_style_tag_t): cfloat

{.pop.}
