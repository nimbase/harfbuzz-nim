## Tests for the C-macro templates and build constants.

import std/unittest

import harfbuzz

test "HB_TAG builds fourcc and HB_UNTAG splits it":
  check HB_TAG('h', 'b', 'x', 'y') == hb_tag_t(0x68627879'u32)
  check HB_UNTAG(HB_TAG('h', 'b', 'x', 'y')) ==
    [0x68'u8, 0x62'u8, 0x78'u8, 0x79'u8]
  check HB_TAG_NONE == hb_tag_t(0)
  check HB_TAG_MAX == hb_tag_t(0xFFFFFFFF'u32)
  check HB_TAG_MAX_SIGNED == hb_tag_t(0x7FFFFFFF'u32)
  check HB_CODEPOINT_INVALID == hb_codepoint_t(0xFFFFFFFF'u32)
  check hb_tag_from_string("liga".cstring, -1) == HB_TAG('l', 'i', 'g', 'a')

test "direction predicates match C bit tricks":
  check HB_DIRECTION_IS_VALID(HB_DIRECTION_LTR)
  check HB_DIRECTION_IS_VALID(HB_DIRECTION_BTT)
  check not HB_DIRECTION_IS_VALID(HB_DIRECTION_INVALID)
  check HB_DIRECTION_IS_HORIZONTAL(HB_DIRECTION_LTR)
  check HB_DIRECTION_IS_HORIZONTAL(HB_DIRECTION_RTL)
  check not HB_DIRECTION_IS_HORIZONTAL(HB_DIRECTION_TTB)
  check HB_DIRECTION_IS_VERTICAL(HB_DIRECTION_TTB)
  check HB_DIRECTION_IS_VERTICAL(HB_DIRECTION_BTT)
  check HB_DIRECTION_IS_FORWARD(HB_DIRECTION_LTR)
  check HB_DIRECTION_IS_FORWARD(HB_DIRECTION_TTB)
  check HB_DIRECTION_IS_BACKWARD(HB_DIRECTION_RTL)
  check HB_DIRECTION_IS_BACKWARD(HB_DIRECTION_BTT)
  check HB_DIRECTION_REVERSE(HB_DIRECTION_LTR) == HB_DIRECTION_RTL
  check HB_DIRECTION_REVERSE(HB_DIRECTION_BTT) == HB_DIRECTION_TTB
  check $hb_direction_to_string(HB_DIRECTION_RTL) == "rtl"
  check hb_direction_from_string("ttb", -1) == HB_DIRECTION_TTB

test "HB_COLOR packs and extracts BGRA channels":
  let c = HB_COLOR(0x11, 0x22, 0x33, 0x44)
  check hb_color_get_blue(c) == 0x11'u8
  check hb_color_get_green(c) == 0x22'u8
  check hb_color_get_red(c) == 0x33'u8
  check hb_color_get_alpha(c) == 0x44'u8

test "cluster level predicates classify all levels":
  check HB_BUFFER_CLUSTER_LEVEL_IS_MONOTONE(
    HB_BUFFER_CLUSTER_LEVEL_MONOTONE_GRAPHEMES)
  check HB_BUFFER_CLUSTER_LEVEL_IS_MONOTONE(
    HB_BUFFER_CLUSTER_LEVEL_MONOTONE_CHARACTERS)
  check not HB_BUFFER_CLUSTER_LEVEL_IS_MONOTONE(
    HB_BUFFER_CLUSTER_LEVEL_CHARACTERS)
  check not HB_BUFFER_CLUSTER_LEVEL_IS_MONOTONE(
    HB_BUFFER_CLUSTER_LEVEL_GRAPHEMES)
  check HB_BUFFER_CLUSTER_LEVEL_IS_GRAPHEMES(
    HB_BUFFER_CLUSTER_LEVEL_GRAPHEMES)
  check not HB_BUFFER_CLUSTER_LEVEL_IS_GRAPHEMES(
    HB_BUFFER_CLUSTER_LEVEL_CHARACTERS)
  check HB_BUFFER_CLUSTER_LEVEL_IS_CHARACTERS(
    HB_BUFFER_CLUSTER_LEVEL_CHARACTERS)
  check HB_BUFFER_CLUSTER_LEVEL_IS_CHARACTERS(
    HB_BUFFER_CLUSTER_LEVEL_MONOTONE_CHARACTERS)
  check not HB_BUFFER_CLUSTER_LEVEL_IS_CHARACTERS(
    HB_BUFFER_CLUSTER_LEVEL_MONOTONE_GRAPHEMES)
  check HB_BUFFER_CLUSTER_LEVEL_DEFAULT ==
    HB_BUFFER_CLUSTER_LEVEL_MONOTONE_GRAPHEMES

test "default segment properties are empty":
  var props = HB_SEGMENT_PROPERTIES_DEFAULT()
  check props.direction == HB_DIRECTION_INVALID
  check props.script == HB_SCRIPT_INVALID
  check props.language == HB_LANGUAGE_INVALID
  check hb_segment_properties_equal(addr props,
    addr props) != 0

test "version and feature constants describe this build":
  check HB_VERSION_MAJOR == 14
  check HB_VERSION_MINOR == 2
  check HB_VERSION_MICRO == 1
  check HB_VERSION_STRING == "14.2.1"
  check HB_VERSION_ATLEAST(14, 2, 1)
  check not HB_VERSION_ATLEAST(99, 0, 0)
  check HB_HAS_SUBSET
  check HB_HAS_RASTER
  check HB_HAS_VECTOR
  check not HB_HAS_ICU
  check not HB_HAS_GPU
  check HB_PAINT_IMAGE_FORMAT_PNG == HB_TAG('p', 'n', 'g', ' ')
  check HB_PAINT_IMAGE_FORMAT_SVG == HB_TAG('s', 'v', 'g', ' ')
  check HB_PAINT_IMAGE_FORMAT_BGRA == HB_TAG('B', 'G', 'R', 'A')
  check HB_UNICODE_MAX == hb_codepoint_t(0x10FFFF'u32)
  check HB_SET_VALUE_INVALID == HB_CODEPOINT_INVALID
  check HB_MAP_VALUE_INVALID == HB_CODEPOINT_INVALID
  check HB_BUFFER_REPLACEMENT_CODEPOINT_DEFAULT ==
    hb_codepoint_t(0xFFFD'u32)
  check HB_OT_SHAPE_BUFFER_FORMAT_SERIAL == 1
