## Bindings for hb-blob.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common

export hb_common

type
  hb_memory_mode_t* {.size: 4.} = enum
    HB_MEMORY_MODE_DUPLICATE = 0
    HB_MEMORY_MODE_READONLY = 1
    HB_MEMORY_MODE_WRITABLE = 2
    HB_MEMORY_MODE_READONLY_MAY_MAKE_WRITABLE = 3

  hb_blob_t* = object

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_blob_create*(data: cstring; length: cuint; mode: hb_memory_mode_t;
                     user_data: pointer;
                     destroy: hb_destroy_func_t): ptr hb_blob_t
proc hb_blob_create_or_fail*(data: cstring; length: cuint;
                             mode: hb_memory_mode_t; user_data: pointer;
                             destroy: hb_destroy_func_t): ptr hb_blob_t
proc hb_blob_create_from_file*(file_name: cstring): ptr hb_blob_t
proc hb_blob_create_from_file_or_fail*(file_name: cstring): ptr hb_blob_t
proc hb_blob_create_sub_blob*(parent: ptr hb_blob_t; offset: cuint;
                              length: cuint): ptr hb_blob_t
proc hb_blob_copy_writable_or_fail*(blob: ptr hb_blob_t): ptr hb_blob_t
proc hb_blob_get_empty*(): ptr hb_blob_t
proc hb_blob_reference*(blob: ptr hb_blob_t): ptr hb_blob_t
proc hb_blob_destroy*(blob: ptr hb_blob_t)
proc hb_blob_set_user_data*(blob: ptr hb_blob_t;
                            key: ptr hb_user_data_key_t; data: pointer;
                            destroy: hb_destroy_func_t;
                            replace: hb_bool_t): hb_bool_t
proc hb_blob_get_user_data*(blob: ptr hb_blob_t;
                            key: ptr hb_user_data_key_t): pointer
proc hb_blob_make_immutable*(blob: ptr hb_blob_t)
proc hb_blob_is_immutable*(blob: ptr hb_blob_t): hb_bool_t
proc hb_blob_get_length*(blob: ptr hb_blob_t): cuint
proc hb_blob_get_data*(blob: ptr hb_blob_t; length: ptr cuint): cstring
proc hb_blob_get_data_writable*(blob: ptr hb_blob_t;
                                length: ptr cuint): cstring

{.pop.}
