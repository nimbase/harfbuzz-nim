# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## Bindings for hb-draw.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common

export hb_common

type
  hb_draw_state_t* = object
    path_open*: hb_bool_t
    path_start_x*: cfloat
    path_start_y*: cfloat
    current_x*: cfloat
    current_y*: cfloat
    reserved1*: hb_var_num_t
    reserved2*: hb_var_num_t
    reserved3*: hb_var_num_t
    reserved4*: hb_var_num_t
    reserved5*: hb_var_num_t
    reserved6*: hb_var_num_t
    reserved7*: hb_var_num_t

  hb_draw_funcs_t* = object

  hb_draw_move_to_func_t* =
    proc(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
         st: ptr hb_draw_state_t; to_x: cfloat; to_y: cfloat;
         user_data: pointer) {.cdecl.}

  hb_draw_line_to_func_t* =
    proc(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
         st: ptr hb_draw_state_t; to_x: cfloat; to_y: cfloat;
         user_data: pointer) {.cdecl.}

  hb_draw_quadratic_to_func_t* =
    proc(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
         st: ptr hb_draw_state_t; control_x: cfloat; control_y: cfloat;
         to_x: cfloat; to_y: cfloat; user_data: pointer) {.cdecl.}

  hb_draw_cubic_to_func_t* =
    proc(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
         st: ptr hb_draw_state_t; control1_x: cfloat; control1_y: cfloat;
         control2_x: cfloat; control2_y: cfloat; to_x: cfloat; to_y: cfloat;
         user_data: pointer) {.cdecl.}

  hb_draw_close_path_func_t* =
    proc(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
         st: ptr hb_draw_state_t; user_data: pointer) {.cdecl.}

  hb_draw_line_cap_t* {.size: 4.} = enum
    HB_DRAW_LINE_CAP_BUTT = 0
    HB_DRAW_LINE_CAP_SQUARE = 1

proc HB_DRAW_STATE_DEFAULT*(): hb_draw_state_t =
  hb_draw_state_t(path_open: 0)

{.push header: "<harfbuzz/hb.h>", importc, cdecl.}

proc hb_draw_funcs_set_move_to_func*(dfuncs: ptr hb_draw_funcs_t;
                                     `func`: hb_draw_move_to_func_t;
                                     user_data: pointer;
                                     destroy: hb_destroy_func_t)
proc hb_draw_funcs_set_line_to_func*(dfuncs: ptr hb_draw_funcs_t;
                                     `func`: hb_draw_line_to_func_t;
                                     user_data: pointer;
                                     destroy: hb_destroy_func_t)
proc hb_draw_funcs_set_quadratic_to_func*(dfuncs: ptr hb_draw_funcs_t;
                                          `func`: hb_draw_quadratic_to_func_t;
                                          user_data: pointer;
                                          destroy: hb_destroy_func_t)
proc hb_draw_funcs_set_cubic_to_func*(dfuncs: ptr hb_draw_funcs_t;
                                      `func`: hb_draw_cubic_to_func_t;
                                      user_data: pointer;
                                      destroy: hb_destroy_func_t)
proc hb_draw_funcs_set_close_path_func*(dfuncs: ptr hb_draw_funcs_t;
                                        `func`: hb_draw_close_path_func_t;
                                        user_data: pointer;
                                        destroy: hb_destroy_func_t)
proc hb_draw_funcs_create*(): ptr hb_draw_funcs_t
proc hb_draw_funcs_get_empty*(): ptr hb_draw_funcs_t
proc hb_draw_funcs_reference*(dfuncs: ptr hb_draw_funcs_t): ptr hb_draw_funcs_t
proc hb_draw_funcs_destroy*(dfuncs: ptr hb_draw_funcs_t)
proc hb_draw_funcs_set_user_data*(dfuncs: ptr hb_draw_funcs_t;
                                  key: ptr hb_user_data_key_t; data: pointer;
                                  destroy: hb_destroy_func_t;
                                  replace: hb_bool_t): hb_bool_t
proc hb_draw_funcs_get_user_data*(dfuncs: ptr hb_draw_funcs_t;
                                  key: ptr hb_user_data_key_t): pointer
proc hb_draw_funcs_make_immutable*(dfuncs: ptr hb_draw_funcs_t)
proc hb_draw_funcs_is_immutable*(dfuncs: ptr hb_draw_funcs_t): hb_bool_t
proc hb_draw_move_to*(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
                      st: ptr hb_draw_state_t; to_x: cfloat; to_y: cfloat)
proc hb_draw_line_to*(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
                      st: ptr hb_draw_state_t; to_x: cfloat; to_y: cfloat)
proc hb_draw_quadratic_to*(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
                           st: ptr hb_draw_state_t; control_x: cfloat;
                           control_y: cfloat; to_x: cfloat; to_y: cfloat)
proc hb_draw_cubic_to*(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
                       st: ptr hb_draw_state_t; control1_x: cfloat;
                       control1_y: cfloat; control2_x: cfloat;
                       control2_y: cfloat; to_x: cfloat; to_y: cfloat)
proc hb_draw_close_path*(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
                         st: ptr hb_draw_state_t)
proc hb_draw_line*(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
                   st: ptr hb_draw_state_t; x0: cfloat; y0: cfloat;
                   w0: cfloat; x1: cfloat; y1: cfloat; w1: cfloat;
                   cap: hb_draw_line_cap_t)
proc hb_draw_rectangle*(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
                        st: ptr hb_draw_state_t; x: cfloat; y: cfloat;
                        w: cfloat; h: cfloat; stroke_width: cfloat)
proc hb_draw_circle*(dfuncs: ptr hb_draw_funcs_t; draw_data: pointer;
                     st: ptr hb_draw_state_t; cx: cfloat; cy: cfloat;
                     r: cfloat; stroke_width: cfloat)

{.pop.}
