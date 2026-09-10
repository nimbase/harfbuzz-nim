import hb_testutils
let face = openTestFace()
# No ot funcs, no scale: raw font
block:
  let font = hb_font_create(face)
  var gidA: hb_codepoint_t = 0
  discard hb_font_get_nominal_glyph(font, 0x41, addr gidA)
  var x, y: hb_position_t
  echo "no-funcs no-scale pt0: ", hb_font_get_glyph_contour_point(font, gidA, 0, addr x, addr y)
  hb_font_destroy(font)
# ot funcs, scale 1000
block:
  let font = hb_font_create(face)
  hb_ot_font_set_funcs(font)
  hb_font_set_scale(font, 1000, 1000)
  var gidA: hb_codepoint_t = 0
  discard hb_font_get_nominal_glyph(font, 0x41, addr gidA)
  var x, y: hb_position_t
  echo "ot-funcs scale1000 pt0: ", hb_font_get_glyph_contour_point(font, gidA, 0, addr x, addr y), " x=", x, " y=", y
  hb_font_destroy(font)
hb_face_destroy(face)
