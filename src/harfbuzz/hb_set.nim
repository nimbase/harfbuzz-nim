# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## Bindings for hb-set.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common

export hb_common

const
  HB_SET_VALUE_INVALID* = HB_CODEPOINT_INVALID

type
  hb_set_t* = object

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_set_create*(): ptr hb_set_t
proc hb_set_get_empty*(): ptr hb_set_t
proc hb_set_reference*(set: ptr hb_set_t): ptr hb_set_t
proc hb_set_destroy*(set: ptr hb_set_t)
proc hb_set_set_user_data*(set: ptr hb_set_t; key: ptr hb_user_data_key_t;
                           data: pointer; destroy: hb_destroy_func_t;
                           replace: hb_bool_t): hb_bool_t
proc hb_set_get_user_data*(set: ptr hb_set_t;
                           key: ptr hb_user_data_key_t): pointer
proc hb_set_allocation_successful*(set: ptr hb_set_t): hb_bool_t
proc hb_set_copy*(set: ptr hb_set_t): ptr hb_set_t
proc hb_set_clear*(set: ptr hb_set_t)
proc hb_set_is_empty*(set: ptr hb_set_t): hb_bool_t
proc hb_set_invert*(set: ptr hb_set_t)
proc hb_set_is_inverted*(set: ptr hb_set_t): hb_bool_t
proc hb_set_has*(set: ptr hb_set_t; codepoint: hb_codepoint_t): hb_bool_t
proc hb_set_add*(set: ptr hb_set_t; codepoint: hb_codepoint_t)
proc hb_set_add_range*(set: ptr hb_set_t; first: hb_codepoint_t;
                       last: hb_codepoint_t)
proc hb_set_add_sorted_array*(set: ptr hb_set_t;
                              sorted_codepoints: ptr hb_codepoint_t;
                              num_codepoints: cuint)
proc hb_set_del*(set: ptr hb_set_t; codepoint: hb_codepoint_t)
proc hb_set_del_range*(set: ptr hb_set_t; first: hb_codepoint_t;
                       last: hb_codepoint_t)
proc hb_set_is_equal*(set: ptr hb_set_t; other: ptr hb_set_t): hb_bool_t
proc hb_set_hash*(set: ptr hb_set_t): cuint
proc hb_set_is_subset*(set: ptr hb_set_t;
                       larger_set: ptr hb_set_t): hb_bool_t
proc hb_set_set*(set: ptr hb_set_t; other: ptr hb_set_t)
proc hb_set_union*(set: ptr hb_set_t; other: ptr hb_set_t)
proc hb_set_intersect*(set: ptr hb_set_t; other: ptr hb_set_t)
proc hb_set_subtract*(set: ptr hb_set_t; other: ptr hb_set_t)
proc hb_set_symmetric_difference*(set: ptr hb_set_t; other: ptr hb_set_t)
proc hb_set_get_population*(set: ptr hb_set_t): cuint
proc hb_set_get_min*(set: ptr hb_set_t): hb_codepoint_t
proc hb_set_get_max*(set: ptr hb_set_t): hb_codepoint_t
proc hb_set_next*(set: ptr hb_set_t;
                  codepoint: ptr hb_codepoint_t): hb_bool_t
proc hb_set_previous*(set: ptr hb_set_t;
                      codepoint: ptr hb_codepoint_t): hb_bool_t
proc hb_set_next_range*(set: ptr hb_set_t; first: ptr hb_codepoint_t;
                        last: ptr hb_codepoint_t): hb_bool_t
proc hb_set_previous_range*(set: ptr hb_set_t; first: ptr hb_codepoint_t;
                            last: ptr hb_codepoint_t): hb_bool_t
proc hb_set_next_many*(set: ptr hb_set_t; codepoint: hb_codepoint_t;
                       `out`: ptr hb_codepoint_t; size: cuint): cuint

{.pop.}
