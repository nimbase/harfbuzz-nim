## Bindings for hb-shape.h (HarfBuzz 14.2.1).
##
## hb_shape_justify() is experimental (HB_EXPERIMENTAL_API) and not part
## of the stable ABI, so it is intentionally not bound.

import harfbuzz/hb_common
import harfbuzz/hb_buffer
import harfbuzz/hb_font

export hb_common
export hb_buffer
export hb_font

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_shape*(font: ptr hb_font_t; buffer: ptr hb_buffer_t;
               features: ptr hb_feature_t; num_features: cuint)
proc hb_shape_full*(font: ptr hb_font_t; buffer: ptr hb_buffer_t;
                    features: ptr hb_feature_t; num_features: cuint;
                    shaper_list: ptr cstring): hb_bool_t
proc hb_shape_list_shapers*(): ptr cstring

{.pop.}
