## Tests for face queries and OpenType layout/metrics/name/color APIs.

import std/unittest

import hb_testutils

test "face exposes tables unicodes and upem":
  let face = openTestFace()
  check hb_face_get_upem(face) == 2048
  check hb_face_get_glyph_count(face) > 3000
  check hb_face_get_index(face) == 0
  var count: cuint = 64
  var tags = newSeq[hb_tag_t](64)
  let total = hb_face_get_table_tags(face, 0, addr count, addr tags[0])
  check total > 10
  check count == total
  check HB_TAG('g', 'l', 'y', 'f') in tags
  check HB_TAG('c', 'm', 'a', 'p') in tags
  check hb_face_is_immutable(face) == 0
  let unicodes = hb_set_create()
  hb_face_collect_unicodes(face, unicodes)
  check hb_set_has(unicodes, 0x41) != 0
  check hb_set_get_population(unicodes) > 1000
  let mapping = hb_map_create()
  let present = hb_set_create()
  hb_face_collect_nominal_glyph_mapping(face, mapping, present)
  check hb_set_has(present, 0x41) != 0
  var gidA: hb_codepoint_t = 0
  let font = openTestFont(face)
  check hb_font_get_nominal_glyph(font, 0x41, addr gidA) != 0
  check hb_map_get(mapping, 0x41) == gidA
  hb_font_destroy(font)
  hb_set_destroy(unicodes)
  hb_map_destroy(mapping)
  hb_set_destroy(present)
  hb_face_destroy(face)

test "dejavu has gsub substitution and gpos positioning":
  let face = openTestFace()
  check hb_ot_layout_has_substitution(face) != 0
  check hb_ot_layout_has_positioning(face) != 0
  var scriptCount: cuint = 0
  let nScripts = hb_ot_layout_table_get_script_tags(face,
    HB_OT_TAG_GSUB, 0, addr scriptCount, nil)
  check nScripts > 0
  var featureCount: cuint = 0
  let nFeatures = hb_ot_layout_table_get_feature_tags(face,
    HB_OT_TAG_GSUB, 0, addr featureCount, nil)
  check nFeatures > 0
  var features = newSeq[hb_tag_t](nFeatures)
  var again: cuint = nFeatures
  discard hb_ot_layout_table_get_feature_tags(face, HB_OT_TAG_GSUB, 0,
    addr again, addr features[0])
  check HB_TAG('l', 'i', 'g', 'a') in features
  check hb_ot_layout_get_size_params(face, nil, nil, nil, nil,
    nil) == 0
  hb_face_destroy(face)

test "ot metrics and variation state on a static font":
  let face = openTestFace()
  let font = openTestFont(face)
  var pos: hb_position_t = 0
  check hb_ot_metrics_get_position(font,
    HB_OT_METRICS_TAG_X_HEIGHT, addr pos) == 0
  hb_ot_metrics_get_position_with_fallback(font,
    HB_OT_METRICS_TAG_X_HEIGHT, addr pos)
  check hb_ot_var_has_data(face) == 0
  check hb_ot_var_get_axis_count(face) == 0
  check hb_ot_var_get_named_instance_count(face) == 0
  hb_font_destroy(font)
  hb_face_destroy(face)

test "name table lists family name":
  let face = openTestFace()
  var numEntries: cuint = 0
  let entries = hb_ot_name_list_names(face, addr numEntries)
  check numEntries > 0
  check entries != nil
  var size: cuint = 256
  var text = newSeq[char](256)
  let length = hb_ot_name_get_utf8(face, 1,
    hb_language_from_string("en".cstring, -1), addr size,
    cast[cstring](addr text[0]))
  check length > 0
  var name = ""
  for i in 0 ..< length.int:
    name.add(text[i])
  check name == "DejaVu Sans"
  hb_face_destroy(face)

test "dejavu carries no color tables":
  let face = openTestFace()
  check hb_ot_color_has_palettes(face) == 0
  check hb_ot_color_has_layers(face) == 0
  check hb_ot_color_has_paint(face) == 0
  check hb_ot_color_has_svg(face) == 0
  check hb_ot_color_has_png(face) == 0
  hb_face_destroy(face)

test "baseline query without BASE table fails cleanly":
  let face = openTestFace()
  let font = openTestFont(face)
  var coord: hb_position_t = 0
  check hb_ot_layout_get_baseline(font,
    HB_OT_LAYOUT_BASELINE_TAG_ROMAN, HB_DIRECTION_LTR,
    HB_OT_TAG_DEFAULT_SCRIPT, HB_OT_TAG_DEFAULT_LANGUAGE,
    addr coord) == 0
  check hb_ot_layout_get_horizontal_baseline_tag_for_script(
    HB_SCRIPT_LATIN) == HB_OT_LAYOUT_BASELINE_TAG_ROMAN
  hb_font_destroy(font)
  hb_face_destroy(face)
