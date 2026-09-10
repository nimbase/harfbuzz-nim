## Tests for buffer content handling, serialization and comparison.

import std/unittest

import hb_testutils

test "buffer starts empty and unicode-typed":
  let buffer = hb_buffer_create()
  check hb_buffer_get_content_type(buffer) ==
    HB_BUFFER_CONTENT_TYPE_INVALID
  check hb_buffer_get_length(buffer) == 0
  hb_buffer_set_content_type(buffer, HB_BUFFER_CONTENT_TYPE_UNICODE)
  check hb_buffer_get_content_type(buffer) ==
    HB_BUFFER_CONTENT_TYPE_UNICODE
  check hb_buffer_get_direction(buffer) == HB_DIRECTION_INVALID
  hb_buffer_destroy(buffer)

test "add utf16 utf32 latin1 codepoints":
  let face = openTestFace()
  let font = openTestFont(face)
  block:
    let buffer = hb_buffer_create()
    var text = [uint16(0x48), uint16(0x69)]
    hb_buffer_add_utf16(buffer, addr text[0], 2, 0, 2)
    hb_buffer_guess_segment_properties(buffer)
    hb_shape(font, buffer, nil, 0)
    check bufferInfos(buffer).len == 2
    hb_buffer_destroy(buffer)
  block:
    let buffer = hb_buffer_create()
    var text = [uint32(0x48), uint32(0x69)]
    hb_buffer_add_utf32(buffer, addr text[0], 2, 0, 2)
    hb_buffer_guess_segment_properties(buffer)
    hb_shape(font, buffer, nil, 0)
    check bufferInfos(buffer).len == 2
    hb_buffer_destroy(buffer)
  block:
    let buffer = hb_buffer_create()
    var text = [uint8(0x41), uint8(0x42)]
    hb_buffer_add_latin1(buffer, addr text[0], 2, 0, 2)
    hb_buffer_guess_segment_properties(buffer)
    hb_shape(font, buffer, nil, 0)
    let infos = bufferInfos(buffer)
    check infos.len == 2
    check infos[0].codepoint != infos[1].codepoint
    hb_buffer_destroy(buffer)
  block:
    let buffer = hb_buffer_create()
    var text = [hb_codepoint_t(0x41), hb_codepoint_t(0x42)]
    hb_buffer_add_codepoints(buffer, addr text[0], 2, 0, 2)
    hb_buffer_guess_segment_properties(buffer)
    hb_shape(font, buffer, nil, 0)
    check bufferInfos(buffer).len == 2
    hb_buffer_destroy(buffer)
  hb_font_destroy(font)
  hb_face_destroy(face)

test "reverse swaps codepoints before shaping":
  let buffer = hb_buffer_create()
  hb_buffer_add_utf8(buffer, "AB".cstring, 2, 0, 2)
  hb_buffer_reverse(buffer)
  var len: cuint = 0
  let infos = hb_buffer_get_glyph_infos(buffer, addr len)
  check len == 2
  let arr = cast[ptr UncheckedArray[hb_glyph_info_t]](infos)
  check arr[0].codepoint == hb_codepoint_t(ord('B'))
  check arr[1].codepoint == hb_codepoint_t(ord('A'))
  hb_buffer_destroy(buffer)

test "serialize and deserialize roundtrip as text":
  let face = openTestFace()
  let font = openTestFont(face)
  let buffer = shapeTestText(font, "Hi!")
  var outBuf = newSeq[char](4096)
  var consumed: cuint = 0
  let n = hb_buffer_serialize_glyphs(buffer, 0,
    hb_buffer_get_length(buffer), cast[cstring](addr outBuf[0]), 4096, addr consumed,
    font, HB_BUFFER_SERIALIZE_FORMAT_TEXT,
    HB_BUFFER_SERIALIZE_FLAG_DEFAULT)
  check n > 0
  check consumed > 0
  let second = hb_buffer_create()
  var endPtr: cstring = nil
  check hb_buffer_deserialize_glyphs(second, cast[cstring](addr outBuf[0]),
    cint(consumed), addr endPtr, font,
    HB_BUFFER_SERIALIZE_FORMAT_TEXT) != 0
  check hb_buffer_get_length(second) == hb_buffer_get_length(buffer)
  check hb_buffer_diff(buffer, second, 0, 0) ==
    HB_BUFFER_DIFF_FLAG_EQUAL
  hb_buffer_destroy(buffer)
  hb_buffer_destroy(second)
  hb_font_destroy(font)
  hb_face_destroy(face)

test "flags replacement glyph and random state roundtrip":
  let buffer = hb_buffer_create()
  hb_buffer_set_flags(buffer, HB_BUFFER_FLAG_BOT)
  check hb_buffer_get_flags(buffer) == HB_BUFFER_FLAG_BOT
  check hb_buffer_get_replacement_codepoint(buffer) ==
    HB_BUFFER_REPLACEMENT_CODEPOINT_DEFAULT
  hb_buffer_set_replacement_codepoint(buffer, 0x41)
  check hb_buffer_get_replacement_codepoint(buffer) == 0x41
  check hb_buffer_get_invisible_glyph(buffer) == 0
  hb_buffer_set_invisible_glyph(buffer, 7)
  check hb_buffer_get_invisible_glyph(buffer) == 7
  hb_buffer_set_not_found_glyph(buffer, 9)
  check hb_buffer_get_not_found_glyph(buffer) == 9
  hb_buffer_set_random_state(buffer, 1234)
  check hb_buffer_get_random_state(buffer) == 1234
  check hb_buffer_set_length(buffer, 4) != 0
  check hb_buffer_get_length(buffer) == 4
  check hb_buffer_pre_allocate(buffer, 64) != 0
  check hb_buffer_allocation_successful(buffer) != 0
  hb_buffer_clear_contents(buffer)
  check hb_buffer_get_length(buffer) == 0
  hb_buffer_destroy(buffer)

test "cluster level and language set get roundtrip":
  let buffer = hb_buffer_create()
  check hb_buffer_get_cluster_level(buffer) ==
    HB_BUFFER_CLUSTER_LEVEL_DEFAULT
  hb_buffer_set_cluster_level(buffer,
    HB_BUFFER_CLUSTER_LEVEL_MONOTONE_CHARACTERS)
  check hb_buffer_get_cluster_level(buffer) ==
    HB_BUFFER_CLUSTER_LEVEL_MONOTONE_CHARACTERS
  hb_buffer_set_language(buffer,
    hb_language_from_string("en".cstring, -1))
  check hb_buffer_get_language(buffer) != nil
  check hb_language_matches(hb_language_from_string("en".cstring, -1),
    hb_language_from_string("en-US".cstring, -1)) != 0
  check $hb_language_to_string(
    hb_language_from_string("de".cstring, -1)) == "de"
  hb_buffer_destroy(buffer)

test "message func observes shaping steps":
  var calls = 0
  proc onMessage(buffer: ptr hb_buffer_t; font: ptr hb_font_t;
                 message: cstring; userData: pointer): hb_bool_t {.cdecl.} =
    inc calls
    1
  let face = openTestFace()
  let font = openTestFont(face)
  let buffer = hb_buffer_create()
  hb_buffer_add_utf8(buffer, "Test".cstring, 4, 0, 4)
  hb_buffer_guess_segment_properties(buffer)
  hb_buffer_set_message_func(buffer,
    onMessage, nil, nil)
  hb_shape(font, buffer, nil, 0)
  check calls > 0
  hb_buffer_destroy(buffer)
  hb_font_destroy(font)
  hb_face_destroy(face)
