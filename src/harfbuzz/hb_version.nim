## Bindings for hb-version.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common

export hb_common

const
  HB_VERSION_MAJOR* = 14
  HB_VERSION_MINOR* = 2
  HB_VERSION_MICRO* = 1
  HB_VERSION_STRING* = "14.2.1"

template HB_VERSION_ATLEAST*(major, minor, micro: untyped): bool =
  (major) * 10000 + (minor) * 100 + (micro) <=
    HB_VERSION_MAJOR * 10000 + HB_VERSION_MINOR * 100 + HB_VERSION_MICRO

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_version*(major: ptr cuint; minor: ptr cuint; micro: ptr cuint)
proc hb_version_string*(): cstring
proc hb_version_atleast*(major: cuint; minor: cuint;
                         micro: cuint): hb_bool_t

{.pop.}
