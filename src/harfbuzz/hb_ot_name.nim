## Bindings for hb-ot-name.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_face

export hb_common
export hb_face

type
  hb_ot_name_id_predefined_t* {.size: 4.} = enum
    HB_OT_NAME_ID_COPYRIGHT = 0
    HB_OT_NAME_ID_FONT_FAMILY = 1
    HB_OT_NAME_ID_FONT_SUBFAMILY = 2
    HB_OT_NAME_ID_UNIQUE_ID = 3
    HB_OT_NAME_ID_FULL_NAME = 4
    HB_OT_NAME_ID_VERSION_STRING = 5
    HB_OT_NAME_ID_POSTSCRIPT_NAME = 6
    HB_OT_NAME_ID_TRADEMARK = 7
    HB_OT_NAME_ID_MANUFACTURER = 8
    HB_OT_NAME_ID_DESIGNER = 9
    HB_OT_NAME_ID_DESCRIPTION = 10
    HB_OT_NAME_ID_VENDOR_URL = 11
    HB_OT_NAME_ID_DESIGNER_URL = 12
    HB_OT_NAME_ID_LICENSE = 13
    HB_OT_NAME_ID_LICENSE_URL = 14
    HB_OT_NAME_ID_TYPOGRAPHIC_FAMILY = 16
    HB_OT_NAME_ID_TYPOGRAPHIC_SUBFAMILY = 17
    HB_OT_NAME_ID_MAC_FULL_NAME = 18
    HB_OT_NAME_ID_SAMPLE_TEXT = 19
    HB_OT_NAME_ID_CID_FINDFONT_NAME = 20
    HB_OT_NAME_ID_WWS_FAMILY = 21
    HB_OT_NAME_ID_WWS_SUBFAMILY = 22
    HB_OT_NAME_ID_LIGHT_BACKGROUND = 23
    HB_OT_NAME_ID_DARK_BACKGROUND = 24
    HB_OT_NAME_ID_VARIATIONS_PS_PREFIX = 25
    HB_OT_NAME_ID_INVALID = 0xFFFF

  hb_ot_name_id_t* = cuint

  hb_ot_name_entry_t* = object
    name_id*: hb_ot_name_id_t
    `var`*: hb_var_int_t
    language*: hb_language_t

{.push header: "<harfbuzz/hb-ot.h>", importc, cdecl.}

proc hb_ot_name_list_names*(face: ptr hb_face_t;
                            num_entries: ptr cuint): ptr hb_ot_name_entry_t
proc hb_ot_name_get_utf8*(face: ptr hb_face_t; name_id: hb_ot_name_id_t;
                          language: hb_language_t; text_size: ptr cuint;
                          text: cstring): cuint
proc hb_ot_name_get_utf16*(face: ptr hb_face_t; name_id: hb_ot_name_id_t;
                           language: hb_language_t; text_size: ptr cuint;
                           text: ptr uint16): cuint
proc hb_ot_name_get_utf32*(face: ptr hb_face_t; name_id: hb_ot_name_id_t;
                           language: hb_language_t; text_size: ptr cuint;
                           text: ptr uint32): cuint

{.pop.}
