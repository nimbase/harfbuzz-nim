# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## Bindings for hb-map.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_set

export hb_common
export hb_set

const
  HB_MAP_VALUE_INVALID* = HB_CODEPOINT_INVALID

type
  hb_map_t* = object

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_map_create*(): ptr hb_map_t
proc hb_map_get_empty*(): ptr hb_map_t
proc hb_map_reference*(map: ptr hb_map_t): ptr hb_map_t
proc hb_map_destroy*(map: ptr hb_map_t)
proc hb_map_set_user_data*(map: ptr hb_map_t; key: ptr hb_user_data_key_t;
                           data: pointer; destroy: hb_destroy_func_t;
                           replace: hb_bool_t): hb_bool_t
proc hb_map_get_user_data*(map: ptr hb_map_t;
                           key: ptr hb_user_data_key_t): pointer
proc hb_map_allocation_successful*(map: ptr hb_map_t): hb_bool_t
proc hb_map_copy*(map: ptr hb_map_t): ptr hb_map_t
proc hb_map_clear*(map: ptr hb_map_t)
proc hb_map_is_empty*(map: ptr hb_map_t): hb_bool_t
proc hb_map_get_population*(map: ptr hb_map_t): cuint
proc hb_map_is_equal*(map: ptr hb_map_t; other: ptr hb_map_t): hb_bool_t
proc hb_map_hash*(map: ptr hb_map_t): cuint
proc hb_map_set*(map: ptr hb_map_t; key: hb_codepoint_t;
                 value: hb_codepoint_t)
proc hb_map_get*(map: ptr hb_map_t; key: hb_codepoint_t): hb_codepoint_t
proc hb_map_del*(map: ptr hb_map_t; key: hb_codepoint_t)
proc hb_map_has*(map: ptr hb_map_t; key: hb_codepoint_t): hb_bool_t
proc hb_map_update*(map: ptr hb_map_t; other: ptr hb_map_t)
proc hb_map_next*(map: ptr hb_map_t; idx: ptr cint;
                  key: ptr hb_codepoint_t;
                  value: ptr hb_codepoint_t): hb_bool_t
proc hb_map_keys*(map: ptr hb_map_t; keys: ptr hb_set_t)
proc hb_map_values*(map: ptr hb_map_t; values: ptr hb_set_t)

{.pop.}
