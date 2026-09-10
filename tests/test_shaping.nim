## Binding smoke tests: lifecycle, shaping, table callbacks, subset, icu.
##
## Uses tests/data/DejaVuSans.ttf (see LICENSE.dejavu.txt).

import std/unittest
import std/os

import harfbuzz

const fontPath = currentSourcePath().parentDir() / "data" / "DejaVuSans.ttf"

proc openFace(): ptr hb_face_t =
  let blob = hb_blob_create_from_file_or_fail(fontPath.cstring)
  check blob != nil
  let face = hb_face_create(blob, 0)
  check face != nil
  hb_blob_destroy(blob)
  face

proc openFont(face: ptr hb_face_t): ptr hb_font_t =
  let font = hb_font_create(face)
  check font != nil
  hb_ot_font_set_funcs(font)
  let upem = hb_face_get_upem(face)
  check upem > 0
  hb_font_set_scale(font, cint(upem), cint(upem))
  font

proc shapeText(font: ptr hb_font_t; text: string): tuple[
    infos: seq[hb_glyph_info_t]; positions: seq[hb_glyph_position_t]] =
  let buffer = hb_buffer_create()
  check buffer != nil
  hb_buffer_add_utf8(buffer, text.cstring, cint(text.len), 0, cint(text.len))
  hb_buffer_guess_segment_properties(buffer)
  hb_shape(font, buffer, nil, 0)
  var len: cuint = 0
  let infos = hb_buffer_get_glyph_infos(buffer, addr len)
  check infos != nil
  var infosSeq = newSeq[hb_glyph_info_t](len)
  copyMem(addr infosSeq[0], infos, len * cuint(sizeof(hb_glyph_info_t)))
  var plen: cuint = 0
  let positions = hb_buffer_get_glyph_positions(buffer, addr plen)
  check positions != nil
  check plen == len
  var posSeq = newSeq[hb_glyph_position_t](plen)
  copyMem(addr posSeq[0], positions,
    plen * cuint(sizeof(hb_glyph_position_t)))
  hb_buffer_destroy(buffer)
  (infosSeq, posSeq)

# test "version matches linked library":
#   check $hb_version_string() == "14.2.1"
#   check hb_version_atleast(14, 2, 1) != 0
#   check HB_VERSION_ATLEAST(14, 2, 1)

test "blob face font lifecycle":
  let face = openFace()
  check hb_face_get_glyph_count(face) > 0
  let font = openFont(face)
  var extents: hb_font_extents_t
  check hb_font_get_h_extents(font, addr extents) != 0
  check extents.ascender > 0
  check extents.descender < 0
  hb_font_destroy(font)
  hb_face_destroy(face)

test "shape ascii run":
  let face = openFace()
  let font = openFont(face)
  let (infos, positions) = shapeText(font, "Hello")
  check infos.len == 5
  check positions.len == 5
  for i in 0 ..< 5:
    check infos[i].codepoint != 0
    check positions[i].x_advance > 0
    check infos[i].cluster == cuint(i)
  hb_font_destroy(font)
  hb_face_destroy(face)

test "kerned AV pair is tighter than advances sum":
  let face = openFace()
  let font = openFont(face)
  var a, v: hb_codepoint_t
  check hb_font_get_nominal_glyph(font, 0x41, addr a) != 0
  check hb_font_get_nominal_glyph(font, 0x56, addr v) != 0
  let advA = hb_font_get_glyph_h_advance(font, a)
  let advV = hb_font_get_glyph_h_advance(font, v)
  let (infos, positions) = shapeText(font, "AV")
  check infos.len == 2
  let shapedTotal = positions[0].x_advance + positions[1].x_advance
  check shapedTotal < advA + advV
  check shapedTotal > 0
  hb_font_destroy(font)
  hb_face_destroy(face)

test "fi ligature forms one glyph":
  let face = openFace()
  let font = openFont(face)
  let (infos, _) = shapeText(font, "fi")
  check infos.len == 1
  check infos[0].cluster == 0
  hb_font_destroy(font)
  hb_face_destroy(face)

test "face for tables delegates to parsed face":
  let src = openFace()
  proc refTable(face: ptr hb_face_t; tag: hb_tag_t;
                userData: pointer): ptr hb_blob_t {.cdecl.} =
    hb_face_reference_table(cast[ptr hb_face_t](userData), tag)
  let face = hb_face_create_for_tables(refTable, src, nil)
  check face != nil
  check hb_face_get_upem(face) == hb_face_get_upem(src)
  check hb_face_get_glyph_count(face) == hb_face_get_glyph_count(src)
  let font = openFont(face)
  let (infos, _) = shapeText(font, "A")
  check infos.len == 1
  check infos[0].codepoint != 0
  hb_font_destroy(font)
  hb_face_destroy(face)
  hb_face_destroy(src)

test "subset keeps only requested unicodes":
  let face = openFace()
  let fullCount = hb_face_get_glyph_count(face)
  let input = hb_subset_input_create_or_fail()
  check input != nil
  let unicodes = hb_subset_input_unicode_set(input)
  hb_set_add(unicodes, 0x41)
  hb_set_add(unicodes, 0x42)
  let sub = hb_subset_or_fail(face, input)
  check sub != nil
  check hb_face_get_glyph_count(sub) < fullCount
  var a: hb_codepoint_t
  let subFont = hb_font_create(sub)
  hb_ot_font_set_funcs(subFont)
  hb_font_set_scale(subFont, 1000, 1000)
  check hb_font_get_nominal_glyph(subFont, 0x41, addr a) != 0
  check hb_font_get_nominal_glyph(subFont, 0x43, addr a) == 0
  hb_font_destroy(subFont)
  hb_face_destroy(sub)
  hb_subset_input_destroy(input)
  hb_face_destroy(face)

test "icu glue maps latin script and unicode data":
  check hb_icu_script_to_script(USCRIPT_LATIN) == HB_SCRIPT_LATIN
  check hb_icu_script_from_script(HB_SCRIPT_LATIN) == USCRIPT_LATIN
  let ufuncs = hb_icu_get_unicode_funcs()
  check ufuncs != nil
  check hb_unicode_combining_class(ufuncs, 0x0301) ==
    HB_UNICODE_COMBINING_CLASS_ABOVE
  check hb_unicode_general_category(ufuncs, 0x41) ==
    HB_UNICODE_GENERAL_CATEGORY_UPPERCASE_LETTER
