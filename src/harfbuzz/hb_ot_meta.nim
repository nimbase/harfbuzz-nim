# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## Bindings for hb-ot-meta.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_blob
import harfbuzz/hb_face

export hb_common
export hb_blob
export hb_face

type
  hb_ot_meta_tag_t* {.size: 4.} = enum
    HB_OT_META_TAG_DESIGN_LANGUAGES = 0x646C6E67
    HB_OT_META_TAG_SUPPORTED_LANGUAGES = 0x736C6E67
    HB_OT_META_TAG_MAX_VALUE = 0x7FFFFFFF

{.push header: "<harfbuzz/hb-ot.h>", importc, cdecl.}

proc hb_ot_meta_get_entry_tags*(face: ptr hb_face_t; start_offset: cuint;
                                entries_count: ptr cuint;
                                entries: ptr hb_ot_meta_tag_t): cuint
proc hb_ot_meta_reference_entry*(face: ptr hb_face_t;
                                 meta_tag: hb_ot_meta_tag_t): ptr hb_blob_t

{.pop.}
