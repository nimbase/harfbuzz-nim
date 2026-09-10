## Bindings for hb-ot-shape.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_buffer
import harfbuzz/hb_font
import harfbuzz/hb_set
import harfbuzz/hb_shape_plan

export hb_common
export hb_buffer
export hb_font
export hb_set
export hb_shape_plan

const
  HB_OT_SHAPE_BUFFER_FORMAT_SERIAL* = 1

{.push header: "<harfbuzz/hb-ot.h>", importc, cdecl.}

proc hb_ot_shape_glyphs_closure*(font: ptr hb_font_t; buffer: ptr hb_buffer_t;
                                 features: ptr hb_feature_t;
                                 num_features: cuint; glyphs: ptr hb_set_t)
proc hb_ot_shape_plan_collect_lookups*(shape_plan: ptr hb_shape_plan_t;
                                       table_tag: hb_tag_t;
                                       lookup_indexes: ptr hb_set_t)
proc hb_ot_shape_plan_get_feature_tags*(shape_plan: ptr hb_shape_plan_t;
                                        start_offset: cuint;
                                        tag_count: ptr cuint;
                                        tags: ptr hb_tag_t): cuint
proc hb_ot_shape_get_buffer_format_serial*(): cuint

{.pop.}
