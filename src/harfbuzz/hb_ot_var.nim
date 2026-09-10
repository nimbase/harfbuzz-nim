## Bindings for hb-ot-var.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_face
import harfbuzz/hb_ot_name

export hb_common
export hb_face
export hb_ot_name

const
  HB_OT_TAG_VAR_AXIS_ITALIC* = hb_tag_t(0x6974616C'u32)
  HB_OT_TAG_VAR_AXIS_OPTICAL_SIZE* = hb_tag_t(0x6F70737A'u32)
  HB_OT_TAG_VAR_AXIS_SLANT* = hb_tag_t(0x736C6E74'u32)
  HB_OT_TAG_VAR_AXIS_WIDTH* = hb_tag_t(0x77647468'u32)
  HB_OT_TAG_VAR_AXIS_WEIGHT* = hb_tag_t(0x77676874'u32)

type
  hb_ot_var_axis_flags_t* {.size: 4.} = enum
    HB_OT_VAR_AXIS_FLAG_HIDDEN = 0x00000001
    HB_OT_VAR_AXIS_FLAG_MAX_VALUE = 0x7FFFFFFF

  hb_ot_var_axis_info_t* = object
    axis_index*: cuint
    tag*: hb_tag_t
    name_id*: hb_ot_name_id_t
    flags*: hb_ot_var_axis_flags_t
    min_value*: cfloat
    default_value*: cfloat
    max_value*: cfloat
    reserved*: cuint

{.push header: "<harfbuzz/hb-ot.h>", importc, cdecl.}

proc hb_ot_var_has_data*(face: ptr hb_face_t): hb_bool_t
proc hb_ot_var_get_axis_count*(face: ptr hb_face_t): cuint
proc hb_ot_var_get_axis_infos*(face: ptr hb_face_t; start_offset: cuint;
                               axes_count: ptr cuint;
                               axes_array: ptr hb_ot_var_axis_info_t): cuint
proc hb_ot_var_find_axis_info*(face: ptr hb_face_t; axis_tag: hb_tag_t;
                               axis_info: ptr hb_ot_var_axis_info_t): hb_bool_t
proc hb_ot_var_get_named_instance_count*(face: ptr hb_face_t): cuint
proc hb_ot_var_named_instance_get_subfamily_name_id*(
    face: ptr hb_face_t; instance_index: cuint): hb_ot_name_id_t
proc hb_ot_var_named_instance_get_postscript_name_id*(
    face: ptr hb_face_t; instance_index: cuint): hb_ot_name_id_t
proc hb_ot_var_named_instance_get_design_coords*(
    face: ptr hb_face_t; instance_index: cuint; coords_length: ptr cuint;
    coords: ptr cfloat): cuint
proc hb_ot_var_normalize_variations*(face: ptr hb_face_t;
                                     variations: ptr hb_variation_t;
                                     variations_length: cuint;
                                     coords: ptr cint;
                                     coords_length: cuint)
proc hb_ot_var_normalize_coords*(face: ptr hb_face_t; coords_length: cuint;
                                 design_coords: ptr cfloat;
                                 normalized_coords: ptr cint)

{.pop.}
