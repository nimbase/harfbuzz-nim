## Bindings for hb-face.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_blob
import harfbuzz/hb_set
import harfbuzz/hb_map

export hb_common
export hb_blob
export hb_set
export hb_map

type
  hb_face_t* = object

  hb_reference_table_func_t* =
    proc(face: ptr hb_face_t; tag: hb_tag_t;
         user_data: pointer): ptr hb_blob_t {.cdecl.}

  hb_get_table_tags_func_t* =
    proc(face: ptr hb_face_t; start_offset: cuint;
         table_count: ptr cuint; table_tags: ptr hb_tag_t;
         user_data: pointer): cuint {.cdecl.}

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_face_count*(blob: ptr hb_blob_t): cuint
proc hb_face_create*(blob: ptr hb_blob_t; index: cuint): ptr hb_face_t
proc hb_face_create_or_fail*(blob: ptr hb_blob_t;
                             index: cuint): ptr hb_face_t
proc hb_face_create_or_fail_using*(blob: ptr hb_blob_t; index: cuint;
                                   loader_name: cstring): ptr hb_face_t
proc hb_face_create_from_file_or_fail*(file_name: cstring;
                                       index: cuint): ptr hb_face_t
proc hb_face_create_from_file_or_fail_using*(file_name: cstring;
                                             index: cuint;
                                             loader_name: cstring): ptr hb_face_t
proc hb_face_list_loaders*(): ptr cstring
proc hb_face_create_for_tables*(
    `reference_table_func`: hb_reference_table_func_t; user_data: pointer;
    destroy: hb_destroy_func_t): ptr hb_face_t
proc hb_face_get_empty*(): ptr hb_face_t
proc hb_face_reference*(face: ptr hb_face_t): ptr hb_face_t
proc hb_face_destroy*(face: ptr hb_face_t)
proc hb_face_set_user_data*(face: ptr hb_face_t;
                            key: ptr hb_user_data_key_t; data: pointer;
                            destroy: hb_destroy_func_t;
                            replace: hb_bool_t): hb_bool_t
proc hb_face_get_user_data*(face: ptr hb_face_t;
                            key: ptr hb_user_data_key_t): pointer
proc hb_face_make_immutable*(face: ptr hb_face_t)
proc hb_face_is_immutable*(face: ptr hb_face_t): hb_bool_t
proc hb_face_reference_table*(face: ptr hb_face_t;
                              tag: hb_tag_t): ptr hb_blob_t
proc hb_face_reference_blob*(face: ptr hb_face_t): ptr hb_blob_t
proc hb_face_set_index*(face: ptr hb_face_t; index: cuint)
proc hb_face_get_index*(face: ptr hb_face_t): cuint
proc hb_face_set_upem*(face: ptr hb_face_t; upem: cuint)
proc hb_face_get_upem*(face: ptr hb_face_t): cuint
proc hb_face_set_glyph_count*(face: ptr hb_face_t; glyph_count: cuint)
proc hb_face_get_glyph_count*(face: ptr hb_face_t): cuint
proc hb_face_set_get_table_tags_func*(face: ptr hb_face_t;
                                      `func`: hb_get_table_tags_func_t;
                                      user_data: pointer;
                                      destroy: hb_destroy_func_t)
proc hb_face_get_table_tags*(face: ptr hb_face_t; start_offset: cuint;
                             table_count: ptr cuint;
                             table_tags: ptr hb_tag_t): cuint
proc hb_face_collect_unicodes*(face: ptr hb_face_t; out_set: ptr hb_set_t)
proc hb_face_collect_nominal_glyph_mapping*(face: ptr hb_face_t;
                                            mapping: ptr hb_map_t;
                                            unicodes: ptr hb_set_t)
proc hb_face_collect_variation_selectors*(face: ptr hb_face_t;
                                          out_set: ptr hb_set_t)
proc hb_face_collect_variation_unicodes*(face: ptr hb_face_t;
                                         variation_selector: hb_codepoint_t;
                                         out_set: ptr hb_set_t)
proc hb_face_builder_create*(): ptr hb_face_t
proc hb_face_builder_add_table*(face: ptr hb_face_t; tag: hb_tag_t;
                                blob: ptr hb_blob_t): hb_bool_t
proc hb_face_builder_sort_tables*(face: ptr hb_face_t;
                                  tags: ptr hb_tag_t)

{.pop.}
