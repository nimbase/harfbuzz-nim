## Tests for glyph extents, outline drawing and paint callbacks.

import std/unittest

import hb_testutils

var drawMoves = 0
var drawLines = 0
var drawQuads = 0
var drawCubics = 0
var drawCloses = 0

proc onMove(dfuncs: ptr hb_draw_funcs_t; drawData: pointer;
            st: ptr hb_draw_state_t; toX: cfloat; toY: cfloat;
            userData: pointer) {.cdecl.} =
  inc drawMoves

proc onLine(dfuncs: ptr hb_draw_funcs_t; drawData: pointer;
            st: ptr hb_draw_state_t; toX: cfloat; toY: cfloat;
            userData: pointer) {.cdecl.} =
  inc drawLines

proc onQuadratic(dfuncs: ptr hb_draw_funcs_t; drawData: pointer;
                 st: ptr hb_draw_state_t; controlX: cfloat;
                 controlY: cfloat; toX: cfloat; toY: cfloat;
                 userData: pointer) {.cdecl.} =
  inc drawQuads

proc onCubic(dfuncs: ptr hb_draw_funcs_t; drawData: pointer;
             st: ptr hb_draw_state_t; control1X: cfloat;
             control1Y: cfloat; control2X: cfloat; control2Y: cfloat;
             toX: cfloat; toY: cfloat; userData: pointer) {.cdecl.} =
  inc drawCubics

proc onClose(dfuncs: ptr hb_draw_funcs_t; drawData: pointer;
             st: ptr hb_draw_state_t; userData: pointer) {.cdecl.} =
  inc drawCloses

test "glyph extents contour point and names":
  let face = openTestFace()
  let font = openTestFont(face)
  var gidA: hb_codepoint_t = 0
  check hb_font_get_nominal_glyph(font, 0x41, addr gidA) != 0
  var extents: hb_glyph_extents_t
  check hb_font_get_glyph_extents(font, gidA, addr extents) != 0
  check extents.width > 0
  check extents.height < 0
  var x, y: hb_position_t
  # Upstream hb-ot-font.cc leaves the contour-point setter commented
  # out (freetype/coretext backends provide it), so the ot funcs
  # report failure here; the binding still round-trips the call.
  check hb_font_get_glyph_contour_point(font, gidA, 0, addr x,
    addr y) == 0
  check hb_font_get_glyph_h_advance(font, gidA) > 0
  var nameBuf = newSeq[char](64)
  check hb_font_get_glyph_name(font, gidA, cast[cstring](addr nameBuf[0]), 64) != 0
  check nameBuf[0] == 'A'
  var fromName: hb_codepoint_t = 0
  check hb_font_get_glyph_from_name(font, cast[cstring](addr nameBuf[0]), -1,
    addr fromName) != 0
  check fromName == gidA
  var strBuf = newSeq[char](64)
  hb_font_glyph_to_string(font, gidA, cast[cstring](addr strBuf[0]), 64)
  check strBuf[0] == 'A'
  var parsed: hb_codepoint_t = 0
  check hb_font_glyph_from_string(font, "A".cstring, -1,
    addr parsed) != 0
  check parsed == gidA
  hb_font_destroy(font)
  hb_face_destroy(face)

test "draw callbacks trace the A outline":
  let face = openTestFace()
  let font = openTestFont(face)
  var gidA: hb_codepoint_t = 0
  check hb_font_get_nominal_glyph(font, 0x41, addr gidA) != 0
  let dfuncs = hb_draw_funcs_create()
  check dfuncs != nil
  hb_draw_funcs_set_move_to_func(dfuncs,
    onMove, nil, nil)
  hb_draw_funcs_set_line_to_func(dfuncs,
    onLine, nil, nil)
  hb_draw_funcs_set_quadratic_to_func(dfuncs,
    onQuadratic, nil, nil)
  hb_draw_funcs_set_cubic_to_func(dfuncs,
    onCubic, nil, nil)
  hb_draw_funcs_set_close_path_func(dfuncs,
    onClose, nil, nil)
  drawMoves = 0
  drawLines = 0
  drawQuads = 0
  drawCubics = 0
  drawCloses = 0
  check hb_font_draw_glyph_or_fail(font, gidA, dfuncs, nil) != 0
  check drawMoves > 0
  check drawLines > 0
  check drawCloses > 0
  check drawMoves + drawLines + drawQuads + drawCubics +
    drawCloses > 10
  hb_draw_funcs_make_immutable(dfuncs)
  check hb_draw_funcs_is_immutable(dfuncs) != 0
  hb_draw_funcs_destroy(dfuncs)
  hb_font_destroy(font)
  hb_face_destroy(face)

var paintColors = 0
var paintGroups = 0
var paintTransforms = 0

proc onPaintColor(funcs: ptr hb_paint_funcs_t; paintData: pointer;
                  isForeground: hb_bool_t; color: hb_color_t;
                  userData: pointer) {.cdecl.} =
  inc paintColors

proc onPushGroup(funcs: ptr hb_paint_funcs_t; paintData: pointer;
                 userData: pointer) {.cdecl.} =
  inc paintGroups

proc onPopGroup(funcs: ptr hb_paint_funcs_t; paintData: pointer;
                mode: hb_paint_composite_mode_t;
                userData: pointer) {.cdecl.} =
  inc paintGroups

proc onPushTransform(funcs: ptr hb_paint_funcs_t; paintData: pointer;
                     xx: cfloat; yx: cfloat; xy: cfloat; yy: cfloat;
                     dx: cfloat; dy: cfloat;
                     userData: pointer) {.cdecl.} =
  inc paintTransforms

proc onPopTransform(funcs: ptr hb_paint_funcs_t; paintData: pointer;
                    userData: pointer) {.cdecl.} =
  inc paintTransforms

test "manual paint calls reach callbacks in order":
  let funcs = hb_paint_funcs_create()
  check funcs != nil
  hb_paint_funcs_set_color_func(funcs,
    onPaintColor, nil, nil)
  hb_paint_funcs_set_push_group_func(funcs,
    onPushGroup, nil, nil)
  hb_paint_funcs_set_pop_group_func(funcs,
    onPopGroup, nil, nil)
  hb_paint_funcs_set_push_transform_func(funcs,
    onPushTransform, nil, nil)
  hb_paint_funcs_set_pop_transform_func(funcs,
    onPopTransform, nil, nil)
  paintColors = 0
  paintGroups = 0
  paintTransforms = 0
  hb_paint_push_transform(funcs, nil, 1, 0, 0, 1, 0, 0)
  hb_paint_push_group(funcs, nil)
  hb_paint_color(funcs, nil, 1, HB_COLOR(0, 0, 0, 255))
  hb_paint_pop_group(funcs, nil, HB_PAINT_COMPOSITE_MODE_SRC_OVER)
  hb_paint_pop_transform(funcs, nil)
  check paintTransforms == 2
  check paintGroups == 2
  check paintColors == 1
  hb_paint_funcs_destroy(funcs)

test "gradient helpers normalize stops and tile sweeps":
  var stops = [hb_color_stop_t(offset: 0, is_foreground: 0,
    color: HB_COLOR(0, 0, 0, 255)),
    hb_color_stop_t(offset: 1, is_foreground: 0,
    color: HB_COLOR(255, 255, 255, 255))]
  var lo, hi: cfloat
  hb_paint_normalize_color_line(addr stops[0], 2, addr lo, addr hi)
  check lo == 0
  check hi == 1
  var xx0, yy0, xx1, yy1: cfloat
  hb_paint_reduce_linear_anchors(0, 0, 1, 0, 0, 1, addr xx0, addr yy0,
    addr xx1, addr yy1)
  var tiles = 0
  proc onTile(a0: cfloat; c0: hb_color_t; a1: cfloat; c1: hb_color_t;
              userData: pointer) {.cdecl.} =
    inc tiles
  hb_paint_sweep_gradient_tiles(addr stops[0], 2,
    HB_PAINT_EXTEND_PAD, 0, 6.2831855, onTile, nil)
  check tiles > 0
