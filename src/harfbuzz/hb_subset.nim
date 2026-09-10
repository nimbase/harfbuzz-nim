## Bindings for hb-subset.h (HarfBuzz 14.2.1).
##
## Links -lharfbuzz-subset. HB_EXPERIMENTAL_API functions
## (hb_subset_input_override_name_table, hb_subset_cff* accessors) are
## intentionally not bound. Experimental enum values carry no link
## dependency and are included.

{.passL: gorge("pkg-config --libs harfbuzz-subset").}

import harfbuzz/hb_common
import harfbuzz/hb_blob
import harfbuzz/hb_face
import harfbuzz/hb_set
import harfbuzz/hb_map
import harfbuzz/hb_ot_name

export hb_common
export hb_blob
export hb_face
export hb_set
export hb_map
export hb_ot_name

type
  hb_subset_input_t* = object
  hb_subset_plan_t* = object

  hb_subset_flags_t* {.size: 4.} = enum
    HB_SUBSET_FLAGS_DEFAULT = 0x00000000
    HB_SUBSET_FLAGS_NO_HINTING = 0x00000001
    HB_SUBSET_FLAGS_RETAIN_GIDS = 0x00000002
    HB_SUBSET_FLAGS_DESUBROUTINIZE = 0x00000004
    HB_SUBSET_FLAGS_NAME_LEGACY = 0x00000008
    HB_SUBSET_FLAGS_SET_OVERLAPS_FLAG = 0x00000010
    HB_SUBSET_FLAGS_PASSTHROUGH_UNRECOGNIZED = 0x00000020
    HB_SUBSET_FLAGS_NOTDEF_OUTLINE = 0x00000040
    HB_SUBSET_FLAGS_GLYPH_NAMES = 0x00000080
    HB_SUBSET_FLAGS_NO_PRUNE_UNICODE_RANGES = 0x00000100
    HB_SUBSET_FLAGS_NO_LAYOUT_CLOSURE = 0x00000200
    HB_SUBSET_FLAGS_OPTIMIZE_IUP_DELTAS = 0x00000400
    HB_SUBSET_FLAGS_NO_BIDI_CLOSURE = 0x00000800
    HB_SUBSET_FLAGS_IFTB_REQUIREMENTS = 0x00001000
    HB_SUBSET_FLAGS_RETAIN_NUM_GLYPHS = 0x00002000
    HB_SUBSET_FLAGS_DOWNGRADE_CFF2 = 0x00004000

  hb_subset_sets_t* {.size: 4.} = enum
    HB_SUBSET_SETS_GLYPH_INDEX = 0
    HB_SUBSET_SETS_UNICODE = 1
    HB_SUBSET_SETS_NO_SUBSET_TABLE_TAG = 2
    HB_SUBSET_SETS_DROP_TABLE_TAG = 3
    HB_SUBSET_SETS_NAME_ID = 4
    HB_SUBSET_SETS_NAME_LANG_ID = 5
    HB_SUBSET_SETS_LAYOUT_FEATURE_TAG = 6
    HB_SUBSET_SETS_LAYOUT_SCRIPT_TAG = 7

{.push header: "<harfbuzz/hb-subset.h>", importc, cdecl.}

proc hb_subset_input_create_or_fail*(): ptr hb_subset_input_t
proc hb_subset_input_reference*(
    input: ptr hb_subset_input_t): ptr hb_subset_input_t
proc hb_subset_input_destroy*(input: ptr hb_subset_input_t)
proc hb_subset_input_set_user_data*(input: ptr hb_subset_input_t;
                                    key: ptr hb_user_data_key_t;
                                    data: pointer;
                                    destroy: hb_destroy_func_t;
                                    replace: hb_bool_t): hb_bool_t
proc hb_subset_input_get_user_data*(input: ptr hb_subset_input_t;
                                    key: ptr hb_user_data_key_t): pointer
proc hb_subset_input_keep_everything*(input: ptr hb_subset_input_t)
proc hb_subset_input_unicode_set*(input: ptr hb_subset_input_t): ptr hb_set_t
proc hb_subset_input_glyph_set*(input: ptr hb_subset_input_t): ptr hb_set_t
proc hb_subset_input_set*(input: ptr hb_subset_input_t;
                          set_type: hb_subset_sets_t): ptr hb_set_t
proc hb_subset_input_old_to_new_glyph_mapping*(
    input: ptr hb_subset_input_t): ptr hb_map_t
proc hb_subset_input_get_flags*(
    input: ptr hb_subset_input_t): hb_subset_flags_t
proc hb_subset_input_set_flags*(input: ptr hb_subset_input_t; value: cuint)
proc hb_subset_input_pin_all_axes_to_default*(input: ptr hb_subset_input_t;
                                              face: ptr hb_face_t): hb_bool_t
proc hb_subset_input_pin_axis_to_default*(input: ptr hb_subset_input_t;
                                          face: ptr hb_face_t;
                                          axis_tag: hb_tag_t): hb_bool_t
proc hb_subset_input_pin_axis_location*(input: ptr hb_subset_input_t;
                                        face: ptr hb_face_t;
                                        axis_tag: hb_tag_t;
                                        axis_value: cfloat): hb_bool_t
proc hb_subset_input_get_axis_range*(input: ptr hb_subset_input_t;
                                     axis_tag: hb_tag_t;
                                     axis_min_value: ptr cfloat;
                                     axis_max_value: ptr cfloat;
                                     axis_def_value: ptr cfloat): hb_bool_t
proc hb_subset_input_set_axis_range*(input: ptr hb_subset_input_t;
                                     face: ptr hb_face_t; axis_tag: hb_tag_t;
                                     axis_min_value: cfloat;
                                     axis_max_value: cfloat;
                                     axis_def_value: cfloat): hb_bool_t
proc hb_subset_axis_range_from_string*(str: cstring; len: cint;
                                       axis_min_value: ptr cfloat;
                                       axis_max_value: ptr cfloat;
                                       axis_def_value: ptr cfloat): hb_bool_t
proc hb_subset_axis_range_to_string*(input: ptr hb_subset_input_t;
                                     axis_tag: hb_tag_t; buf: cstring;
                                     size: cuint)
proc hb_subset_preprocess*(source: ptr hb_face_t): ptr hb_face_t
proc hb_subset_or_fail*(source: ptr hb_face_t;
                        input: ptr hb_subset_input_t): ptr hb_face_t
proc hb_subset_plan_execute_or_fail*(
    plan: ptr hb_subset_plan_t): ptr hb_face_t
proc hb_subset_plan_create_or_fail*(face: ptr hb_face_t;
                                    input: ptr hb_subset_input_t): ptr hb_subset_plan_t
proc hb_subset_plan_destroy*(plan: ptr hb_subset_plan_t)
proc hb_subset_plan_old_to_new_glyph_mapping*(
    plan: ptr hb_subset_plan_t): ptr hb_map_t
proc hb_subset_plan_new_to_old_glyph_mapping*(
    plan: ptr hb_subset_plan_t): ptr hb_map_t
proc hb_subset_plan_unicode_to_old_glyph_mapping*(
    plan: ptr hb_subset_plan_t): ptr hb_map_t
proc hb_subset_plan_reference*(
    plan: ptr hb_subset_plan_t): ptr hb_subset_plan_t
proc hb_subset_plan_set_user_data*(plan: ptr hb_subset_plan_t;
                                   key: ptr hb_user_data_key_t; data: pointer;
                                   destroy: hb_destroy_func_t;
                                   replace: hb_bool_t): hb_bool_t
proc hb_subset_plan_get_user_data*(plan: ptr hb_subset_plan_t;
                                   key: ptr hb_user_data_key_t): pointer

{.pop.}
