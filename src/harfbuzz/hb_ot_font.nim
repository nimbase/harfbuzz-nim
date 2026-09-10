## Bindings for hb-ot-font.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_font

export hb_common
export hb_font

{.push header: "<harfbuzz/hb-ot.h>", importc, cdecl.}

proc hb_ot_font_set_funcs*(font: ptr hb_font_t)

{.pop.}
