# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## Bindings for hb-buffer.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_unicode
import harfbuzz/hb_font

export hb_common
export hb_unicode
export hb_font

type
  hb_glyph_flags_t* {.size: 4.} = enum
    HB_GLYPH_FLAG_UNSAFE_TO_BREAK = 0x00000001
    HB_GLYPH_FLAG_UNSAFE_TO_CONCAT = 0x00000002
    HB_GLYPH_FLAG_SAFE_TO_INSERT_TATWEEL = 0x00000004
    HB_GLYPH_FLAG_DEFINED = 0x00000007

  hb_glyph_info_t* = object
    codepoint*: hb_codepoint_t
    mask*: hb_mask_t
    cluster*: uint32
    var1*: hb_var_int_t
    var2*: hb_var_int_t

  hb_glyph_position_t* = object
    x_advance*: hb_position_t
    y_advance*: hb_position_t
    x_offset*: hb_position_t
    y_offset*: hb_position_t
    `var`*: hb_var_int_t

  hb_segment_properties_t* = object
    direction*: hb_direction_t
    script*: hb_script_t
    language*: hb_language_t
    reserved1*: pointer
    reserved2*: pointer

  hb_buffer_t* = object

  hb_buffer_content_type_t* {.size: 4.} = enum
    HB_BUFFER_CONTENT_TYPE_INVALID = 0
    HB_BUFFER_CONTENT_TYPE_UNICODE = 1
    HB_BUFFER_CONTENT_TYPE_GLYPHS = 2

  hb_buffer_flags_t* {.size: 4.} = enum
    HB_BUFFER_FLAG_DEFAULT = 0x00000000
    HB_BUFFER_FLAG_BOT = 0x00000001
    HB_BUFFER_FLAG_EOT = 0x00000002
    HB_BUFFER_FLAG_PRESERVE_DEFAULT_IGNORABLES = 0x00000004
    HB_BUFFER_FLAG_REMOVE_DEFAULT_IGNORABLES = 0x00000008
    HB_BUFFER_FLAG_DO_NOT_INSERT_DOTTED_CIRCLE = 0x00000010
    HB_BUFFER_FLAG_VERIFY = 0x00000020
    HB_BUFFER_FLAG_PRODUCE_UNSAFE_TO_CONCAT = 0x00000040
    HB_BUFFER_FLAG_PRODUCE_SAFE_TO_INSERT_TATWEEL = 0x00000080
    HB_BUFFER_FLAG_DEFINED = 0x000000FF

  hb_buffer_cluster_level_t* {.size: 4.} = enum
    HB_BUFFER_CLUSTER_LEVEL_MONOTONE_GRAPHEMES = 0
    HB_BUFFER_CLUSTER_LEVEL_MONOTONE_CHARACTERS = 1
    HB_BUFFER_CLUSTER_LEVEL_CHARACTERS = 2
    HB_BUFFER_CLUSTER_LEVEL_GRAPHEMES = 3

  hb_buffer_serialize_flags_t* {.size: 4.} = enum
    HB_BUFFER_SERIALIZE_FLAG_DEFAULT = 0x00000000
    HB_BUFFER_SERIALIZE_FLAG_NO_CLUSTERS = 0x00000001
    HB_BUFFER_SERIALIZE_FLAG_NO_POSITIONS = 0x00000002
    HB_BUFFER_SERIALIZE_FLAG_NO_GLYPH_NAMES = 0x00000004
    HB_BUFFER_SERIALIZE_FLAG_GLYPH_EXTENTS = 0x00000008
    HB_BUFFER_SERIALIZE_FLAG_GLYPH_FLAGS = 0x00000010
    HB_BUFFER_SERIALIZE_FLAG_NO_ADVANCES = 0x00000020
    HB_BUFFER_SERIALIZE_FLAG_DEFINED = 0x0000003F

  hb_buffer_serialize_format_t* {.size: 4.} = enum
    HB_BUFFER_SERIALIZE_FORMAT_TEXT = 0x54455854
    HB_BUFFER_SERIALIZE_FORMAT_JSON = 0x4A534F4E
    HB_BUFFER_SERIALIZE_FORMAT_INVALID = 0

  hb_buffer_diff_flags_t* {.size: 4.} = enum
    HB_BUFFER_DIFF_FLAG_EQUAL = 0x0000
    HB_BUFFER_DIFF_FLAG_CONTENT_TYPE_MISMATCH = 0x0001
    HB_BUFFER_DIFF_FLAG_LENGTH_MISMATCH = 0x0002
    HB_BUFFER_DIFF_FLAG_NOTDEF_PRESENT = 0x0004
    HB_BUFFER_DIFF_FLAG_DOTTED_CIRCLE_PRESENT = 0x0008
    HB_BUFFER_DIFF_FLAG_CODEPOINT_MISMATCH = 0x0010
    HB_BUFFER_DIFF_FLAG_CLUSTER_MISMATCH = 0x0020
    HB_BUFFER_DIFF_FLAG_GLYPH_FLAGS_MISMATCH = 0x0040
    HB_BUFFER_DIFF_FLAG_POSITION_MISMATCH = 0x0080

  hb_buffer_message_func_t* =
    proc(buffer: ptr hb_buffer_t; font: ptr hb_font_t; message: cstring;
         user_data: pointer): hb_bool_t {.cdecl.}

const
  HB_BUFFER_REPLACEMENT_CODEPOINT_DEFAULT* = hb_codepoint_t(0xFFFD'u32)
  HB_BUFFER_CLUSTER_LEVEL_DEFAULT* =
    HB_BUFFER_CLUSTER_LEVEL_MONOTONE_GRAPHEMES

template hb_glyph_info_get_glyph_flags*(
    info: ptr hb_glyph_info_t): hb_glyph_flags_t =
  hb_glyph_flags_t(cuint(info.mask) and cuint(HB_GLYPH_FLAG_DEFINED))

proc HB_SEGMENT_PROPERTIES_DEFAULT*(): hb_segment_properties_t =
  hb_segment_properties_t(direction: HB_DIRECTION_INVALID,
                          script: HB_SCRIPT_INVALID,
                          language: HB_LANGUAGE_INVALID,
                          reserved1: nil, reserved2: nil)

template HB_BUFFER_CLUSTER_LEVEL_IS_MONOTONE*(
    level: hb_buffer_cluster_level_t): bool =
  ((1'u32 shl cuint(level)) and
   ((1'u32 shl cuint(HB_BUFFER_CLUSTER_LEVEL_MONOTONE_GRAPHEMES)) or
    (1'u32 shl cuint(HB_BUFFER_CLUSTER_LEVEL_MONOTONE_CHARACTERS)))) != 0

template HB_BUFFER_CLUSTER_LEVEL_IS_GRAPHEMES*(
    level: hb_buffer_cluster_level_t): bool =
  ((1'u32 shl cuint(level)) and
   ((1'u32 shl cuint(HB_BUFFER_CLUSTER_LEVEL_MONOTONE_GRAPHEMES)) or
    (1'u32 shl cuint(HB_BUFFER_CLUSTER_LEVEL_GRAPHEMES)))) != 0

template HB_BUFFER_CLUSTER_LEVEL_IS_CHARACTERS*(
    level: hb_buffer_cluster_level_t): bool =
  ((1'u32 shl cuint(level)) and
   ((1'u32 shl cuint(HB_BUFFER_CLUSTER_LEVEL_MONOTONE_CHARACTERS)) or
    (1'u32 shl cuint(HB_BUFFER_CLUSTER_LEVEL_CHARACTERS)))) != 0

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_segment_properties_equal*(a: ptr hb_segment_properties_t;
                                 b: ptr hb_segment_properties_t): hb_bool_t
proc hb_segment_properties_hash*(p: ptr hb_segment_properties_t): cuint
proc hb_segment_properties_overlay*(p: ptr hb_segment_properties_t;
                                    src: ptr hb_segment_properties_t)
proc hb_buffer_create*(): ptr hb_buffer_t
proc hb_buffer_create_similar*(src: ptr hb_buffer_t): ptr hb_buffer_t
proc hb_buffer_reset*(buffer: ptr hb_buffer_t)
proc hb_buffer_get_empty*(): ptr hb_buffer_t
proc hb_buffer_reference*(buffer: ptr hb_buffer_t): ptr hb_buffer_t
proc hb_buffer_destroy*(buffer: ptr hb_buffer_t)
proc hb_buffer_set_user_data*(buffer: ptr hb_buffer_t;
                              key: ptr hb_user_data_key_t; data: pointer;
                              destroy: hb_destroy_func_t;
                              replace: hb_bool_t): hb_bool_t
proc hb_buffer_get_user_data*(buffer: ptr hb_buffer_t;
                              key: ptr hb_user_data_key_t): pointer
proc hb_buffer_set_content_type*(buffer: ptr hb_buffer_t;
                                 content_type: hb_buffer_content_type_t)
proc hb_buffer_get_content_type*(
    buffer: ptr hb_buffer_t): hb_buffer_content_type_t
proc hb_buffer_set_unicode_funcs*(buffer: ptr hb_buffer_t;
                                  unicode_funcs: ptr hb_unicode_funcs_t)
proc hb_buffer_get_unicode_funcs*(
    buffer: ptr hb_buffer_t): ptr hb_unicode_funcs_t
proc hb_buffer_set_direction*(buffer: ptr hb_buffer_t;
                              direction: hb_direction_t)
proc hb_buffer_get_direction*(buffer: ptr hb_buffer_t): hb_direction_t
proc hb_buffer_set_script*(buffer: ptr hb_buffer_t; script: hb_script_t)
proc hb_buffer_get_script*(buffer: ptr hb_buffer_t): hb_script_t
proc hb_buffer_set_language*(buffer: ptr hb_buffer_t;
                             language: hb_language_t)
proc hb_buffer_get_language*(buffer: ptr hb_buffer_t): hb_language_t
proc hb_buffer_set_segment_properties*(buffer: ptr hb_buffer_t;
                                       props: ptr hb_segment_properties_t)
proc hb_buffer_get_segment_properties*(buffer: ptr hb_buffer_t;
                                       props: ptr hb_segment_properties_t)
proc hb_buffer_guess_segment_properties*(buffer: ptr hb_buffer_t)
proc hb_buffer_set_flags*(buffer: ptr hb_buffer_t; flags: hb_buffer_flags_t)
proc hb_buffer_get_flags*(buffer: ptr hb_buffer_t): hb_buffer_flags_t
proc hb_buffer_set_cluster_level*(buffer: ptr hb_buffer_t;
                                  cluster_level: hb_buffer_cluster_level_t)
proc hb_buffer_get_cluster_level*(
    buffer: ptr hb_buffer_t): hb_buffer_cluster_level_t
proc hb_buffer_set_replacement_codepoint*(buffer: ptr hb_buffer_t;
                                          replacement: hb_codepoint_t)
proc hb_buffer_get_replacement_codepoint*(
    buffer: ptr hb_buffer_t): hb_codepoint_t
proc hb_buffer_set_invisible_glyph*(buffer: ptr hb_buffer_t;
                                    invisible: hb_codepoint_t)
proc hb_buffer_get_invisible_glyph*(
    buffer: ptr hb_buffer_t): hb_codepoint_t
proc hb_buffer_set_not_found_glyph*(buffer: ptr hb_buffer_t;
                                    not_found: hb_codepoint_t)
proc hb_buffer_get_not_found_glyph*(
    buffer: ptr hb_buffer_t): hb_codepoint_t
proc hb_buffer_set_not_found_variation_selector_glyph*(
    buffer: ptr hb_buffer_t; not_found_variation_selector: hb_codepoint_t)
proc hb_buffer_get_not_found_variation_selector_glyph*(
    buffer: ptr hb_buffer_t): hb_codepoint_t
proc hb_buffer_set_random_state*(buffer: ptr hb_buffer_t; state: cuint)
proc hb_buffer_get_random_state*(buffer: ptr hb_buffer_t): cuint
proc hb_buffer_clear_contents*(buffer: ptr hb_buffer_t)
proc hb_buffer_pre_allocate*(buffer: ptr hb_buffer_t;
                             size: cuint): hb_bool_t
proc hb_buffer_allocation_successful*(buffer: ptr hb_buffer_t): hb_bool_t
proc hb_buffer_reverse*(buffer: ptr hb_buffer_t)
proc hb_buffer_reverse_range*(buffer: ptr hb_buffer_t; start: cuint;
                              `end`: cuint)
proc hb_buffer_reverse_clusters*(buffer: ptr hb_buffer_t)
proc hb_buffer_add*(buffer: ptr hb_buffer_t; codepoint: hb_codepoint_t;
                    cluster: cuint)
proc hb_buffer_add_utf8*(buffer: ptr hb_buffer_t; text: cstring;
                         text_length: cint; item_offset: cuint;
                         item_length: cint)
proc hb_buffer_add_utf16*(buffer: ptr hb_buffer_t; text: ptr uint16;
                          text_length: cint; item_offset: cuint;
                          item_length: cint)
proc hb_buffer_add_utf32*(buffer: ptr hb_buffer_t; text: ptr uint32;
                          text_length: cint; item_offset: cuint;
                          item_length: cint)
proc hb_buffer_add_latin1*(buffer: ptr hb_buffer_t; text: ptr uint8;
                           text_length: cint; item_offset: cuint;
                           item_length: cint)
proc hb_buffer_add_codepoints*(buffer: ptr hb_buffer_t;
                               text: ptr hb_codepoint_t; text_length: cint;
                               item_offset: cuint; item_length: cint)
proc hb_buffer_append*(buffer: ptr hb_buffer_t; source: ptr hb_buffer_t;
                       start: cuint; `end`: cuint)
proc hb_buffer_set_length*(buffer: ptr hb_buffer_t;
                           length: cuint): hb_bool_t
proc hb_buffer_get_length*(buffer: ptr hb_buffer_t): cuint
proc hb_buffer_get_glyph_infos*(buffer: ptr hb_buffer_t;
                                length: ptr cuint): ptr hb_glyph_info_t
proc hb_buffer_get_glyph_positions*(buffer: ptr hb_buffer_t;
                                    length: ptr cuint): ptr hb_glyph_position_t
proc hb_buffer_has_positions*(buffer: ptr hb_buffer_t): hb_bool_t
proc hb_buffer_normalize_glyphs*(buffer: ptr hb_buffer_t)
proc hb_buffer_serialize_format_from_string*(str: cstring;
                                             len: cint): hb_buffer_serialize_format_t
proc hb_buffer_serialize_format_to_string*(
    format: hb_buffer_serialize_format_t): cstring
proc hb_buffer_serialize_list_formats*(): ptr cstring
proc hb_buffer_serialize_glyphs*(buffer: ptr hb_buffer_t; start: cuint;
                                 `end`: cuint; buf: cstring; buf_size: cuint;
                                 buf_consumed: ptr cuint; font: ptr hb_font_t;
                                 format: hb_buffer_serialize_format_t;
                                 flags: hb_buffer_serialize_flags_t): cuint
proc hb_buffer_serialize_unicode*(buffer: ptr hb_buffer_t; start: cuint;
                                  `end`: cuint; buf: cstring; buf_size: cuint;
                                  buf_consumed: ptr cuint;
                                  format: hb_buffer_serialize_format_t;
                                  flags: hb_buffer_serialize_flags_t): cuint
proc hb_buffer_serialize*(buffer: ptr hb_buffer_t; start: cuint;
                          `end`: cuint; buf: cstring; buf_size: cuint;
                          buf_consumed: ptr cuint; font: ptr hb_font_t;
                          format: hb_buffer_serialize_format_t;
                          flags: hb_buffer_serialize_flags_t): cuint
proc hb_buffer_deserialize_glyphs*(buffer: ptr hb_buffer_t; buf: cstring;
                                   buf_len: cint; end_ptr: ptr cstring;
                                   font: ptr hb_font_t;
                                   format: hb_buffer_serialize_format_t): hb_bool_t
proc hb_buffer_deserialize_unicode*(buffer: ptr hb_buffer_t; buf: cstring;
                                    buf_len: cint; end_ptr: ptr cstring;
                                    format: hb_buffer_serialize_format_t): hb_bool_t
proc hb_buffer_diff*(buffer: ptr hb_buffer_t; reference: ptr hb_buffer_t;
                     dottedcircle_glyph: hb_codepoint_t;
                     position_fuzz: cuint): hb_buffer_diff_flags_t
proc hb_buffer_set_message_func*(buffer: ptr hb_buffer_t;
                                 `func`: hb_buffer_message_func_t;
                                 user_data: pointer;
                                 destroy: hb_destroy_func_t)
proc hb_buffer_changed*(buffer: ptr hb_buffer_t)

{.pop.}
