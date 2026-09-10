# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## harfbuzz: low-level Nim bindings for the HarfBuzz text shaping library.
##
## C names are preserved verbatim so upstream code stays greppable.
## Linked via pkg-config (HarfBuzz 14.2.1, MacPorts /opt/local).

{.passC: gorge("pkg-config --cflags harfbuzz").}
{.passL: gorge("pkg-config --libs harfbuzz").}
# Callback signatures are ABI-identical to C (pointer-sized opaques,
# 4-byte enums, POD structs) but differ nominally (Nim type spellings
# vs C tags), which clang 16+ escalates to a hard error when Nim procs
# are registered as C callbacks. Demote back to a warning; see
# hb_common for the full note.
{.passC: "-Wno-incompatible-function-pointer-types".}

import harfbuzz/hb_common
import harfbuzz/hb_version
import harfbuzz/hb_blob
import harfbuzz/hb_set
import harfbuzz/hb_map
import harfbuzz/hb_face
import harfbuzz/hb_draw
import harfbuzz/hb_paint
import harfbuzz/hb_font
import harfbuzz/hb_unicode
import harfbuzz/hb_buffer
import harfbuzz/hb_shape
import harfbuzz/hb_shape_plan
import harfbuzz/hb_style
import harfbuzz/hb_features
import harfbuzz/hb_ot_font
import harfbuzz/hb_ot_shape
import harfbuzz/hb_ot_meta
import harfbuzz/hb_ot_name
import harfbuzz/hb_ot_metrics
import harfbuzz/hb_ot_var
import harfbuzz/hb_ot_color
import harfbuzz/hb_ot_math
import harfbuzz/hb_ot_layout
import harfbuzz/hb_aat_layout
import harfbuzz/hb_subset
import harfbuzz/hb_subset_serialize
import harfbuzz/hb_icu

export hb_common
export hb_version
export hb_blob
export hb_set
export hb_map
export hb_face
export hb_draw
export hb_paint
export hb_font
export hb_unicode
export hb_buffer
export hb_shape
export hb_shape_plan
export hb_style
export hb_features
export hb_ot_font
export hb_ot_shape
export hb_ot_meta
export hb_ot_name
export hb_ot_metrics
export hb_ot_var
export hb_ot_color
export hb_ot_math
export hb_ot_layout
export hb_aat_layout
export hb_subset
export hb_subset_serialize
export hb_icu
