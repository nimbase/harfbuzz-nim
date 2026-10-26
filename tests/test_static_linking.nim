## Smoke test for externally supplied static archives; also runs in shared mode.
## See README.md for static compiler flags.
import std/[assertions, os]

import harfbuzz

proc onMove(
    funcs: ptr hb_draw_funcs_t,
    data: pointer,
    state: ptr hb_draw_state_t,
    x, y: cfloat,
    userData: pointer,
) {.cdecl.} =
  inc cast[ptr int](data)[]

block staticCapi:
  doAssert hb_version_atleast(7, 0, 0) != 0
  let path = currentSourcePath().parentDir / "data" / "DejaVuSans.ttf"
  let blob = hb_blob_create_from_file_or_fail(path.cstring)
  doAssert blob != nil
  defer:
    hb_blob_destroy(blob)
  let face = hb_face_create(blob, 0)
  defer:
    hb_face_destroy(face)
  let font = hb_font_create(face)
  defer:
    hb_font_destroy(font)
  hb_ot_font_set_funcs(font)

  let buffer = hb_buffer_create()
  defer:
    hb_buffer_destroy(buffer)
  hb_buffer_add_utf8(buffer, "A", 1, 0, 1)
  hb_buffer_set_direction(buffer, HB_DIRECTION_LTR)
  hb_buffer_set_script(buffer, HB_SCRIPT_LATIN)
  let language = hb_language_from_string("en", -1)
  hb_buffer_set_language(buffer, language)
  doAssert $hb_language_to_string(language) == "en"
  var feature: hb_feature_t
  doAssert hb_feature_from_string("kern=0", -1, addr feature) != 0
  var variation: hb_variation_t
  doAssert hb_variation_from_string("wght=600", -1, addr variation) != 0
  hb_font_set_variations(font, addr variation, 1)
  var properties: hb_segment_properties_t
  hb_buffer_get_segment_properties(buffer, addr properties)
  doAssert properties.direction == HB_DIRECTION_LTR
  doAssert properties.script == HB_SCRIPT_LATIN
  doAssert properties.language == language
  when defined(harfbuzzStatic):
    proc stringValue(value: cstring): string =
      $value

    doAssert stringValue(hb_version_string()).len > 0
    doAssert stringValue(hb_direction_to_string(HB_DIRECTION_LTR)) == "ltr"
    doAssert stringValue(hb_language_to_string(language)) == "en"
    var blobLength: cuint
    let data: cstring = hb_blob_get_data(blob, addr blobLength)
    doAssert data != nil and blobLength > 0
    let listShapers = hb_shape_list_shapers
    let listFormats = hb_buffer_serialize_list_formats
    let shapeFull = hb_shape_full
    let createPlan = hb_shape_plan_create
    let createCachedPlan = hb_shape_plan_create_cached
    doAssert listShapers() != nil
    doAssert listFormats() != nil
    let emptyPlan = createPlan(hb_face_get_empty(), addr properties, nil, 0, nil)
    hb_shape_plan_destroy(emptyPlan)
    let cachedPlan = createCachedPlan(hb_face_get_empty(), addr properties, nil, 0, nil)
    hb_shape_plan_destroy(cachedPlan)
    let emptyBuffer = hb_buffer_create()
    doAssert shapeFull(hb_font_get_empty(), emptyBuffer, nil, 0, nil) != 0
    hb_buffer_destroy(emptyBuffer)
  let plan = hb_shape_plan_create_cached(face, addr properties, addr feature, 1, nil)
  doAssert plan != nil
  defer:
    hb_shape_plan_destroy(plan)
  doAssert hb_shape_plan_execute(plan, font, buffer, addr feature, 1) != 0
  var count: cuint
  let infos = hb_buffer_get_glyph_infos(buffer, addr count)
  doAssert count == 1
  doAssert infos[].codepoint != 0
  var extents: hb_glyph_extents_t
  doAssert hb_font_get_glyph_extents(font, infos[].codepoint, addr extents) != 0
  doAssert extents.width > 0

  let funcs = hb_draw_funcs_create()
  defer:
    hb_draw_funcs_destroy(funcs)
  hb_draw_funcs_set_move_to_func(funcs, onMove, nil, nil)
  var moves = 0
  hb_font_draw_glyph(font, infos[].codepoint, funcs, addr moves)
  doAssert moves > 0

  let input = hb_subset_input_create_or_fail()
  defer:
    hb_subset_input_destroy(input)
  hb_set_add(hb_subset_input_unicode_set(input), 0x41)
  hb_subset_input_set_flags(input, HB_SUBSET_FLAGS_NO_HINTING)
  doAssert hb_subset_input_get_flags(input) == HB_SUBSET_FLAGS_NO_HINTING
  let subset = hb_subset_or_fail(face, input)
  doAssert subset != nil
  defer:
    hb_face_destroy(subset)
  doAssert hb_face_get_glyph_count(subset) > 0
