## Bindings for hb-shape-plan.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_buffer
import harfbuzz/hb_font

export hb_common
export hb_buffer
export hb_font

type
  hb_shape_plan_t* = object

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_shape_plan_create*(face: ptr hb_face_t;
                           props: ptr hb_segment_properties_t;
                           user_features: ptr hb_feature_t;
                           num_user_features: cuint;
                           shaper_list: ptr cstring): ptr hb_shape_plan_t
proc hb_shape_plan_create_cached*(face: ptr hb_face_t;
                                  props: ptr hb_segment_properties_t;
                                  user_features: ptr hb_feature_t;
                                  num_user_features: cuint;
                                  shaper_list: ptr cstring): ptr hb_shape_plan_t
proc hb_shape_plan_create2*(face: ptr hb_face_t;
                            props: ptr hb_segment_properties_t;
                            user_features: ptr hb_feature_t;
                            num_user_features: cuint; coords: ptr cint;
                            num_coords: cuint;
                            shaper_list: ptr cstring): ptr hb_shape_plan_t
proc hb_shape_plan_create_cached2*(face: ptr hb_face_t;
                                   props: ptr hb_segment_properties_t;
                                   user_features: ptr hb_feature_t;
                                   num_user_features: cuint; coords: ptr cint;
                                   num_coords: cuint;
                                   shaper_list: ptr cstring): ptr hb_shape_plan_t
proc hb_shape_plan_get_empty*(): ptr hb_shape_plan_t
proc hb_shape_plan_reference*(
    shape_plan: ptr hb_shape_plan_t): ptr hb_shape_plan_t
proc hb_shape_plan_destroy*(shape_plan: ptr hb_shape_plan_t)
proc hb_shape_plan_set_user_data*(shape_plan: ptr hb_shape_plan_t;
                                  key: ptr hb_user_data_key_t; data: pointer;
                                  destroy: hb_destroy_func_t;
                                  replace: hb_bool_t): hb_bool_t
proc hb_shape_plan_get_user_data*(shape_plan: ptr hb_shape_plan_t;
                                  key: ptr hb_user_data_key_t): pointer
proc hb_shape_plan_execute*(shape_plan: ptr hb_shape_plan_t;
                            font: ptr hb_font_t; buffer: ptr hb_buffer_t;
                            features: ptr hb_feature_t;
                            num_features: cuint): hb_bool_t
proc hb_shape_plan_get_shaper*(shape_plan: ptr hb_shape_plan_t): cstring

{.pop.}
