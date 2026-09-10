## Tests for hb-set and hb-map.

import std/unittest

import harfbuzz

test "set add has del":
  let s = hb_set_create()
  check s != nil
  check hb_set_is_empty(s) != 0
  hb_set_add(s, 41)
  hb_set_add(s, 42)
  check hb_set_is_empty(s) == 0
  check hb_set_has(s, 41) != 0
  check hb_set_has(s, 43) == 0
  check hb_set_get_population(s) == 2
  check hb_set_get_min(s) == 41
  check hb_set_get_max(s) == 42
  hb_set_del(s, 41)
  check hb_set_has(s, 41) == 0
  check hb_set_get_population(s) == 1
  hb_set_destroy(s)

test "set ranges and iteration":
  let s = hb_set_create()
  hb_set_add_range(s, 10, 20)
  check hb_set_get_population(s) == 11
  hb_set_del_range(s, 15, 25)
  check hb_set_get_population(s) == 5
  var collected: seq[hb_codepoint_t] = @[]
  var cp: hb_codepoint_t = HB_SET_VALUE_INVALID
  while hb_set_next(s, addr cp) != 0:
    collected.add(cp)
  check collected == @[10'u32, 11'u32, 12'u32, 13'u32, 14'u32]
  var first: hb_codepoint_t = HB_SET_VALUE_INVALID
  var last: hb_codepoint_t = HB_SET_VALUE_INVALID
  check hb_set_next_range(s, addr first, addr last) != 0
  check first == 10
  check last == 14
  var outBuf = newSeq[hb_codepoint_t](8)
  let got = hb_set_next_many(s, HB_SET_VALUE_INVALID, addr outBuf[0], 8)
  check got == 5
  check outBuf[0 ..< 5] == @[10'u32, 11'u32, 12'u32, 13'u32, 14'u32]
  hb_set_destroy(s)

test "set algebra and copy":
  let a = hb_set_create()
  let b = hb_set_create()
  hb_set_add_range(a, 1, 5)
  hb_set_add_range(b, 4, 8)
  let u = hb_set_copy(a)
  hb_set_union(u, b)
  check hb_set_get_population(u) == 8
  let i = hb_set_copy(a)
  hb_set_intersect(i, b)
  check hb_set_get_population(i) == 2
  check hb_set_has(i, 4) != 0
  check hb_set_has(i, 5) != 0
  let d = hb_set_copy(a)
  hb_set_subtract(d, b)
  check hb_set_get_population(d) == 3
  check hb_set_is_subset(d, a) != 0
  check hb_set_is_subset(a, d) == 0
  check hb_set_is_equal(a, a) != 0
  check hb_set_is_equal(a, b) == 0
  hb_set_invert(i)
  check hb_set_has(i, 4) == 0
  check hb_set_has(i, 99) != 0
  check hb_set_is_inverted(i) != 0
  hb_set_clear(i)
  check hb_set_is_empty(i) != 0
  check hb_set_allocation_successful(a) != 0
  check hb_set_hash(a) == hb_set_hash(a)
  hb_set_destroy(a)
  hb_set_destroy(b)
  hb_set_destroy(u)
  hb_set_destroy(i)
  hb_set_destroy(d)

test "map set get del iterate":
  let m = hb_map_create()
  check m != nil
  check hb_map_is_empty(m) != 0
  hb_map_set(m, 1, 100)
  hb_map_set(m, 2, 200)
  check hb_map_is_empty(m) == 0
  check hb_map_get(m, 1) == 100
  check hb_map_get(m, 2) == 200
  check hb_map_get(m, 3) == HB_MAP_VALUE_INVALID
  check hb_map_has(m, 2) != 0
  check hb_map_has(m, 3) == 0
  check hb_map_get_population(m) == 2
  hb_map_del(m, 1)
  check hb_map_has(m, 1) == 0
  var idx: cint = -1
  var key, value: hb_codepoint_t
  check hb_map_next(m, addr idx, addr key, addr value) != 0
  check key == 2
  check value == 200
  check hb_map_next(m, addr idx, addr key, addr value) == 0
  let keys = hb_set_create()
  hb_map_keys(m, keys)
  check hb_set_has(keys, 2) != 0
  let values = hb_set_create()
  hb_map_values(m, values)
  check hb_set_has(values, 200) != 0
  let c = hb_map_copy(m)
  check hb_map_is_equal(m, c) != 0
  check hb_map_hash(m) == hb_map_hash(c)
  let other = hb_map_create()
  hb_map_set(other, 9, 900)
  hb_map_update(m, other)
  check hb_map_get(m, 9) == 900
  check hb_map_allocation_successful(m) != 0
  hb_map_clear(m)
  check hb_map_is_empty(m) != 0
  hb_map_destroy(m)
  hb_map_destroy(c)
  hb_map_destroy(other)
  hb_set_destroy(keys)
  hb_set_destroy(values)
