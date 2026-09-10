# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## Bindings for hb-common.h (HarfBuzz 14.2.1).
##
## C names are preserved verbatim. Function-like macros from the C API
## are Nim templates with identical names and semantics.
##
## C-identity note: Nim object/enum spellings differ nominally from the
## C struct/enum tags (e.g. `char*` vs `const char*`, `int` vs C enum
## names), which clang 16+ rejects as hard errors when Nim procs are
## passed as C callbacks. All signatures here are ABI-identical to C
## (pointer-sized opaques, `{.size: 4.}` enums, POD structs), so the
## root module demotes that diagnostic back to a warning with
## `-Wno-incompatible-function-pointer-types`. Register Nim callbacks
## directly; no casts needed.

import harfbuzz/hb_script_list

export hb_script_list

type
  hb_bool_t* = cint
  hb_codepoint_t* = uint32
  hb_position_t* = int32
  hb_mask_t* = uint32

  hb_var_int_t* {.union.} = object
    u32*: uint32
    i32*: int32
    u16*: array[2, uint16]
    i16*: array[2, int16]
    u8*: array[4, uint8]
    i8*: array[4, int8]

  hb_var_num_t* {.union.} = object
    f*: cfloat
    u32*: uint32
    i32*: int32
    u16*: array[2, uint16]
    i16*: array[2, int16]
    u8*: array[4, uint8]
    i8*: array[4, int8]

  hb_tag_t* = uint32

  hb_direction_t* {.size: 4.} = enum
    HB_DIRECTION_INVALID = 0
    HB_DIRECTION_LTR = 4
    HB_DIRECTION_RTL = 5
    HB_DIRECTION_TTB = 6
    HB_DIRECTION_BTT = 7

  hb_language_impl_t* = object
  hb_language_t* = ptr hb_language_impl_t

  hb_user_data_key_t* = object
    unused*: char

  hb_destroy_func_t* = proc(user_data: pointer) {.cdecl.}

  hb_feature_t* = object
    tag*: hb_tag_t
    value*: uint32
    start*: cuint
    `end`*: cuint

  hb_variation_t* = object
    tag*: hb_tag_t
    value*: cfloat

  hb_color_t* = uint32

  hb_glyph_extents_t* = object
    x_bearing*: hb_position_t
    y_bearing*: hb_position_t
    width*: hb_position_t
    height*: hb_position_t

  hb_font_t* = object

template HB_TAG*(c1, c2, c3, c4: untyped): hb_tag_t =
  hb_tag_t((hb_tag_t(c1) and 0xFF) shl 24 or
           (hb_tag_t(c2) and 0xFF) shl 16 or
           (hb_tag_t(c3) and 0xFF) shl 8 or
           (hb_tag_t(c4) and 0xFF))

template HB_UNTAG*(tag: hb_tag_t): array[4, uint8] =
  [uint8((tag shr 24) and 0xFF), uint8((tag shr 16) and 0xFF),
   uint8((tag shr 8) and 0xFF), uint8(tag and 0xFF)]

const
  HB_TAG_NONE* = hb_tag_t(0)
  HB_TAG_MAX* = hb_tag_t(0xFFFFFFFF'u32)
  HB_TAG_MAX_SIGNED* = hb_tag_t(0x7FFFFFFF'u32)
  HB_CODEPOINT_INVALID* = hb_codepoint_t(0xFFFFFFFF'u32)
  HB_FEATURE_GLOBAL_START* = cuint(0)
  HB_FEATURE_GLOBAL_END* = cuint(0xFFFFFFFF)
  HB_LANGUAGE_INVALID* = hb_language_t(nil)

template HB_DIRECTION_IS_VALID*(dir: hb_direction_t): bool =
  (cuint(dir) and not cuint(3)) == 4

template HB_DIRECTION_IS_HORIZONTAL*(dir: hb_direction_t): bool =
  (cuint(dir) and not cuint(1)) == 4

template HB_DIRECTION_IS_VERTICAL*(dir: hb_direction_t): bool =
  (cuint(dir) and not cuint(1)) == 6

template HB_DIRECTION_IS_FORWARD*(dir: hb_direction_t): bool =
  (cuint(dir) and not cuint(2)) == 4

template HB_DIRECTION_IS_BACKWARD*(dir: hb_direction_t): bool =
  (cuint(dir) and not cuint(2)) == 5

template HB_DIRECTION_REVERSE*(dir: hb_direction_t): hb_direction_t =
  hb_direction_t(cuint(dir) xor 1)

template HB_COLOR*(b, g, r, a: untyped): hb_color_t =
  hb_color_t((hb_color_t(b) and 0xFF) shl 24 or
             (hb_color_t(g) and 0xFF) shl 16 or
             (hb_color_t(r) and 0xFF) shl 8 or
             (hb_color_t(a) and 0xFF))

template hb_color_get_alpha*(color: hb_color_t): uint8 =
  uint8(color and 0xFF)

template hb_color_get_red*(color: hb_color_t): uint8 =
  uint8((color shr 8) and 0xFF)

template hb_color_get_green*(color: hb_color_t): uint8 =
  uint8((color shr 16) and 0xFF)

template hb_color_get_blue*(color: hb_color_t): uint8 =
  uint8((color shr 24) and 0xFF)

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_tag_from_string*(str: cstring; len: cint): hb_tag_t
proc hb_tag_to_string*(tag: hb_tag_t; buf: cstring)

proc hb_direction_from_string*(str: cstring; len: cint): hb_direction_t
proc hb_direction_to_string*(direction: hb_direction_t): cstring

proc hb_language_from_string*(str: cstring; len: cint): hb_language_t
proc hb_language_to_string*(language: hb_language_t): cstring
proc hb_language_get_default*(): hb_language_t
proc hb_language_matches*(language: hb_language_t;
                           specific: hb_language_t): hb_bool_t

proc hb_script_from_iso15924_tag*(tag: hb_tag_t): hb_script_t
proc hb_script_from_string*(str: cstring; len: cint): hb_script_t
proc hb_script_to_iso15924_tag*(script: hb_script_t): hb_tag_t
proc hb_script_get_horizontal_direction*(
    script: hb_script_t): hb_direction_t

proc hb_feature_from_string*(str: cstring; len: cint;
                             feature: ptr hb_feature_t): hb_bool_t
proc hb_feature_to_string*(feature: ptr hb_feature_t; buf: cstring;
                           size: cuint)

proc hb_variation_from_string*(str: cstring; len: cint;
                               variation: ptr hb_variation_t): hb_bool_t
proc hb_variation_to_string*(variation: ptr hb_variation_t; buf: cstring;
                             size: cuint)

proc hb_malloc*(size: csize_t): pointer
proc hb_calloc*(nmemb: csize_t; size: csize_t): pointer
proc hb_realloc*(`ptr`: pointer; size: csize_t): pointer
proc hb_free*(`ptr`: pointer)

{.pop.}
