## Tests for unicode funcs, script/language/tag helpers.

import std/unittest

import harfbuzz

test "default unicode funcs classify codepoints":
  let ufuncs = hb_unicode_funcs_get_default()
  check ufuncs != nil
  check hb_unicode_general_category(ufuncs, 0x41) ==
    HB_UNICODE_GENERAL_CATEGORY_UPPERCASE_LETTER
  check hb_unicode_general_category(ufuncs, 0x61) ==
    HB_UNICODE_GENERAL_CATEGORY_LOWERCASE_LETTER
  check hb_unicode_general_category(ufuncs, 0x30) ==
    HB_UNICODE_GENERAL_CATEGORY_DECIMAL_NUMBER
  check hb_unicode_general_category(ufuncs, 0x20) ==
    HB_UNICODE_GENERAL_CATEGORY_SPACE_SEPARATOR
  check hb_unicode_combining_class(ufuncs, 0x0301) ==
    HB_UNICODE_COMBINING_CLASS_ABOVE
  check hb_unicode_combining_class(ufuncs, 0x41) ==
    HB_UNICODE_COMBINING_CLASS_NOT_REORDERED
  check hb_unicode_script(ufuncs, 0x41) == HB_SCRIPT_LATIN
  check hb_unicode_script(ufuncs, 0x05D0) == HB_SCRIPT_HEBREW
  check hb_unicode_script(ufuncs, 0x0627) == HB_SCRIPT_ARABIC

test "mirroring maps paired punctuation":
  let ufuncs = hb_unicode_funcs_get_default()
  check hb_unicode_mirroring(ufuncs, 0x28) == 0x29
  check hb_unicode_mirroring(ufuncs, 0x41) == 0x41

test "compose and decompose roundtrip e-acute":
  let ufuncs = hb_unicode_funcs_get_default()
  var composed: hb_codepoint_t = 0
  check hb_unicode_compose(ufuncs, 0x65, 0x0301, addr composed) != 0
  check composed == 0xE9
  var a, b: hb_codepoint_t
  check hb_unicode_decompose(ufuncs, 0xE9, addr a, addr b) != 0
  check a == 0x65
  check b == 0x0301

test "script tag conversions roundtrip":
  check hb_script_from_iso15924_tag(HB_TAG('L', 'a', 't', 'n')) ==
    HB_SCRIPT_LATIN
  check hb_script_to_iso15924_tag(HB_SCRIPT_LATIN) ==
    HB_TAG('L', 'a', 't', 'n')
  check hb_script_from_string("Arab".cstring, -1) == HB_SCRIPT_ARABIC
  check hb_script_get_horizontal_direction(HB_SCRIPT_LATIN) ==
    HB_DIRECTION_LTR
  check hb_script_get_horizontal_direction(HB_SCRIPT_ARABIC) ==
    HB_DIRECTION_RTL
  check hb_ot_tag_to_script(HB_TAG('l', 'a', 't', 'n')) ==
    HB_SCRIPT_LATIN
  check hb_ot_tag_to_language(HB_TAG('E', 'N', 'G', ' ')) != nil
  var scriptCount: cuint = 3
  var scriptTags = [hb_tag_t(0), hb_tag_t(0), hb_tag_t(0)]
  var langCount: cuint = 3
  var langTags = [hb_tag_t(0), hb_tag_t(0), hb_tag_t(0)]
  hb_ot_tags_from_script_and_language(HB_SCRIPT_LATIN,
    hb_language_from_string("en".cstring, -1), addr scriptCount,
    addr scriptTags[0], addr langCount, addr langTags[0])
  check scriptCount > 0
  check scriptTags[0] == HB_TAG('l', 'a', 't', 'n')

test "custom unicode funcs override combining class":
  proc combiningClass(ufuncs: ptr hb_unicode_funcs_t;
                      unicode: hb_codepoint_t;
                      userData: pointer): hb_unicode_combining_class_t {.
      cdecl.} =
    HB_UNICODE_COMBINING_CLASS_OVERLAY
  let ufuncs = hb_unicode_funcs_create(nil)
  check ufuncs != nil
  hb_unicode_funcs_set_combining_class_func(ufuncs, combiningClass,
    nil, nil)
  check hb_unicode_combining_class(ufuncs, 0x41) ==
    HB_UNICODE_COMBINING_CLASS_OVERLAY
  hb_unicode_funcs_make_immutable(ufuncs)
  check hb_unicode_funcs_is_immutable(ufuncs) != 0
  let child = hb_unicode_funcs_create(ufuncs)
  check hb_unicode_funcs_get_parent(child) == ufuncs
  hb_unicode_funcs_destroy(child)
  hb_unicode_funcs_destroy(ufuncs)
