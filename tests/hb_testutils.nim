## Shared helpers for the harfbuzz binding tests.

import std/os

import harfbuzz

export harfbuzz

const TestFontPath* = currentSourcePath().parentDir() / "data" /
  "DejaVuSans.ttf"

proc openTestFace*(): ptr hb_face_t =
  let blob = hb_blob_create_from_file_or_fail(TestFontPath.cstring)
  assert blob != nil
  let face = hb_face_create(blob, 0)
  assert face != nil
  hb_blob_destroy(blob)
  face

proc openTestFont*(face: ptr hb_face_t): ptr hb_font_t =
  let font = hb_font_create(face)
  assert font != nil
  hb_ot_font_set_funcs(font)
  let upem = hb_face_get_upem(face)
  assert upem > 0
  hb_font_set_scale(font, cint(upem), cint(upem))
  font

proc shapeTestText*(font: ptr hb_font_t; text: string): ptr hb_buffer_t =
  result = hb_buffer_create()
  assert result != nil
  hb_buffer_add_utf8(result, text.cstring, cint(text.len), 0,
    cint(text.len))
  hb_buffer_guess_segment_properties(result)
  hb_shape(font, result, nil, 0)

proc bufferInfos*(buffer: ptr hb_buffer_t): seq[hb_glyph_info_t] =
  var len: cuint = 0
  let infos = hb_buffer_get_glyph_infos(buffer, addr len)
  assert infos != nil
  result = newSeq[hb_glyph_info_t](len)
  if len > 0:
    copyMem(addr result[0], infos,
      len * cuint(sizeof(hb_glyph_info_t)))

proc bufferPositions*(buffer: ptr hb_buffer_t): seq[hb_glyph_position_t] =
  var len: cuint = 0
  let positions = hb_buffer_get_glyph_positions(buffer, addr len)
  assert positions != nil
  result = newSeq[hb_glyph_position_t](len)
  if len > 0:
    copyMem(addr result[0], positions,
      len * cuint(sizeof(hb_glyph_position_t)))
