# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## Bindings for hb-ot-layout.h (HarfBuzz 14.2.1).

import harfbuzz/hb_common
import harfbuzz/hb_blob
import harfbuzz/hb_face
import harfbuzz/hb_font
import harfbuzz/hb_set
import harfbuzz/hb_map
import harfbuzz/hb_ot_name

export hb_common
export hb_blob
export hb_face
export hb_font
export hb_set
export hb_map
export hb_ot_name

const
  HB_OT_TAG_BASE* = hb_tag_t(0x42415345'u32)
  HB_OT_TAG_GDEF* = hb_tag_t(0x47444546'u32)
  HB_OT_TAG_GSUB* = hb_tag_t(0x47535542'u32)
  HB_OT_TAG_GPOS* = hb_tag_t(0x47504F53'u32)
  HB_OT_TAG_JSTF* = hb_tag_t(0x4A535446'u32)
  HB_OT_TAG_DEFAULT_SCRIPT* = hb_tag_t(0x44464C54'u32)
  HB_OT_TAG_DEFAULT_LANGUAGE* = hb_tag_t(0x64666C74'u32)
  HB_OT_MAX_TAGS_PER_SCRIPT* = cuint(3)
  HB_OT_MAX_TAGS_PER_LANGUAGE* = cuint(3)
  HB_OT_LAYOUT_NO_SCRIPT_INDEX* = 0xFFFF'u32
  HB_OT_LAYOUT_NO_FEATURE_INDEX* = 0xFFFF'u32
  HB_OT_LAYOUT_DEFAULT_LANGUAGE_INDEX* = 0xFFFF'u32
  HB_OT_LAYOUT_NO_VARIATIONS_INDEX* = 0xFFFFFFFF'u32

type
  hb_ot_layout_glyph_class_t* {.size: 4.} = enum
    HB_OT_LAYOUT_GLYPH_CLASS_UNCLASSIFIED = 0
    HB_OT_LAYOUT_GLYPH_CLASS_BASE_GLYPH = 1
    HB_OT_LAYOUT_GLYPH_CLASS_LIGATURE = 2
    HB_OT_LAYOUT_GLYPH_CLASS_MARK = 3
    HB_OT_LAYOUT_GLYPH_CLASS_COMPONENT = 4

  hb_ot_layout_baseline_tag_t* {.size: 4.} = enum
    HB_OT_LAYOUT_BASELINE_TAG_ROMAN = 0x726F6D6E
    HB_OT_LAYOUT_BASELINE_TAG_HANGING = 0x68616E67
    HB_OT_LAYOUT_BASELINE_TAG_IDEO_FACE_BOTTOM_OR_LEFT = 0x69636662
    HB_OT_LAYOUT_BASELINE_TAG_IDEO_FACE_TOP_OR_RIGHT = 0x69636674
    HB_OT_LAYOUT_BASELINE_TAG_IDEO_FACE_CENTRAL = 0x49636663
    HB_OT_LAYOUT_BASELINE_TAG_IDEO_EMBOX_BOTTOM_OR_LEFT = 0x6964656F
    HB_OT_LAYOUT_BASELINE_TAG_IDEO_EMBOX_TOP_OR_RIGHT = 0x69647470
    HB_OT_LAYOUT_BASELINE_TAG_IDEO_EMBOX_CENTRAL = 0x49646365
    HB_OT_LAYOUT_BASELINE_TAG_MATH = 0x6D617468
    HB_OT_LAYOUT_BASELINE_TAG_MAX_VALUE = 0x7FFFFFFF

{.push header: "<harfbuzz/hb-ot.h>", importc, cdecl.}

proc hb_ot_tags_from_script_and_language*(script: hb_script_t;
                                          language: hb_language_t;
                                          script_count: ptr cuint;
                                          script_tags: ptr hb_tag_t;
                                          language_count: ptr cuint;
                                          language_tags: ptr hb_tag_t)
proc hb_ot_tag_to_script*(tag: hb_tag_t): hb_script_t
proc hb_ot_tag_to_language*(tag: hb_tag_t): hb_language_t
proc hb_ot_tags_to_script_and_language*(script_tag: hb_tag_t;
                                        language_tag: hb_tag_t;
                                        script: ptr hb_script_t;
                                        language: ptr hb_language_t)
proc hb_ot_layout_has_glyph_classes*(face: ptr hb_face_t): hb_bool_t
proc hb_ot_layout_get_glyph_class*(face: ptr hb_face_t;
                                   glyph: hb_codepoint_t): hb_ot_layout_glyph_class_t
proc hb_ot_layout_get_glyphs_in_class*(face: ptr hb_face_t;
                                       klass: hb_ot_layout_glyph_class_t;
                                       glyphs: ptr hb_set_t)
proc hb_ot_layout_get_attach_points*(face: ptr hb_face_t;
                                     glyph: hb_codepoint_t;
                                     start_offset: cuint;
                                     point_count: ptr cuint;
                                     point_array: ptr cuint): cuint
proc hb_ot_layout_get_ligature_carets*(font: ptr hb_font_t;
                                       direction: hb_direction_t;
                                       glyph: hb_codepoint_t;
                                       start_offset: cuint;
                                       caret_count: ptr cuint;
                                       caret_array: ptr hb_position_t): cuint
proc hb_ot_layout_table_get_script_tags*(face: ptr hb_face_t;
                                         table_tag: hb_tag_t;
                                         start_offset: cuint;
                                         script_count: ptr cuint;
                                         script_tags: ptr hb_tag_t): cuint
proc hb_ot_layout_table_find_script*(face: ptr hb_face_t; table_tag: hb_tag_t;
                                     script_tag: hb_tag_t;
                                     script_index: ptr cuint): hb_bool_t
proc hb_ot_layout_table_select_script*(face: ptr hb_face_t;
                                       table_tag: hb_tag_t;
                                       script_count: cuint;
                                       script_tags: ptr hb_tag_t;
                                       script_index: ptr cuint;
                                       chosen_script: ptr hb_tag_t): hb_bool_t
proc hb_ot_layout_table_get_feature_tags*(face: ptr hb_face_t;
                                          table_tag: hb_tag_t;
                                          start_offset: cuint;
                                          feature_count: ptr cuint;
                                          feature_tags: ptr hb_tag_t): cuint
proc hb_ot_layout_script_get_language_tags*(face: ptr hb_face_t;
                                            table_tag: hb_tag_t;
                                            script_index: cuint;
                                            start_offset: cuint;
                                            language_count: ptr cuint;
                                            language_tags: ptr hb_tag_t): cuint
proc hb_ot_layout_script_select_language*(face: ptr hb_face_t;
                                          table_tag: hb_tag_t;
                                          script_index: cuint;
                                          language_count: cuint;
                                          language_tags: ptr hb_tag_t;
                                          language_index: ptr cuint): hb_bool_t
proc hb_ot_layout_script_select_language2*(face: ptr hb_face_t;
                                           table_tag: hb_tag_t;
                                           script_index: cuint;
                                           language_count: cuint;
                                           language_tags: ptr hb_tag_t;
                                           language_index: ptr cuint;
                                           chosen_language: ptr hb_tag_t): hb_bool_t
proc hb_ot_layout_language_get_required_feature_index*(
    face: ptr hb_face_t; table_tag: hb_tag_t; script_index: cuint;
    language_index: cuint; feature_index: ptr cuint): hb_bool_t
proc hb_ot_layout_language_get_required_feature*(
    face: ptr hb_face_t; table_tag: hb_tag_t; script_index: cuint;
    language_index: cuint; feature_index: ptr cuint;
    feature_tag: ptr hb_tag_t): hb_bool_t
proc hb_ot_layout_language_get_feature_indexes*(
    face: ptr hb_face_t; table_tag: hb_tag_t; script_index: cuint;
    language_index: cuint; start_offset: cuint; feature_count: ptr cuint;
    feature_indexes: ptr cuint): cuint
proc hb_ot_layout_language_get_feature_tags*(
    face: ptr hb_face_t; table_tag: hb_tag_t; script_index: cuint;
    language_index: cuint; start_offset: cuint; feature_count: ptr cuint;
    feature_tags: ptr hb_tag_t): cuint
proc hb_ot_layout_language_find_feature*(face: ptr hb_face_t;
                                         table_tag: hb_tag_t;
                                         script_index: cuint;
                                         language_index: cuint;
                                         feature_tag: hb_tag_t;
                                         feature_index: ptr cuint): hb_bool_t
proc hb_ot_layout_feature_get_lookups*(face: ptr hb_face_t;
                                       table_tag: hb_tag_t;
                                       feature_index: cuint;
                                       start_offset: cuint;
                                       lookup_count: ptr cuint;
                                       lookup_indexes: ptr cuint): cuint
proc hb_ot_layout_table_get_lookup_count*(face: ptr hb_face_t;
                                          table_tag: hb_tag_t): cuint
proc hb_ot_layout_collect_features*(face: ptr hb_face_t; table_tag: hb_tag_t;
                                    scripts: ptr hb_tag_t;
                                    languages: ptr hb_tag_t;
                                    features: ptr hb_tag_t;
                                    feature_indexes: ptr hb_set_t)
proc hb_ot_layout_collect_features_map*(face: ptr hb_face_t;
                                        table_tag: hb_tag_t;
                                        script_index: cuint;
                                        language_index: cuint;
                                        feature_map: ptr hb_map_t)
proc hb_ot_layout_collect_lookups*(face: ptr hb_face_t; table_tag: hb_tag_t;
                                   scripts: ptr hb_tag_t;
                                   languages: ptr hb_tag_t;
                                   features: ptr hb_tag_t;
                                   lookup_indexes: ptr hb_set_t)
proc hb_ot_layout_lookup_collect_glyphs*(face: ptr hb_face_t;
                                         table_tag: hb_tag_t;
                                         lookup_index: cuint;
                                         glyphs_before: ptr hb_set_t;
                                         glyphs_input: ptr hb_set_t;
                                         glyphs_after: ptr hb_set_t;
                                         glyphs_output: ptr hb_set_t)
proc hb_ot_layout_table_find_feature_variations*(face: ptr hb_face_t;
                                                 table_tag: hb_tag_t;
                                                 coords: ptr cint;
                                                 num_coords: cuint;
                                                 variations_index: ptr cuint): hb_bool_t
proc hb_ot_layout_feature_with_variations_get_lookups*(
    face: ptr hb_face_t; table_tag: hb_tag_t; feature_index: cuint;
    variations_index: cuint; start_offset: cuint; lookup_count: ptr cuint;
    lookup_indexes: ptr cuint): cuint
proc hb_ot_layout_has_substitution*(face: ptr hb_face_t): hb_bool_t
proc hb_ot_layout_lookup_get_glyph_alternates*(
    face: ptr hb_face_t; lookup_index: cuint; glyph: hb_codepoint_t;
    start_offset: cuint; alternate_count: ptr cuint;
    alternate_glyphs: ptr hb_codepoint_t): cuint
proc hb_ot_layout_lookup_collect_glyph_alternates*(face: ptr hb_face_t;
                                                  lookup_index: cuint;
                                                  alternate_count: ptr hb_map_t;
                                                  alternate_glyphs: ptr hb_map_t): hb_bool_t
proc hb_ot_layout_lookup_would_substitute*(face: ptr hb_face_t;
                                           lookup_index: cuint;
                                           glyphs: ptr hb_codepoint_t;
                                           glyphs_length: cuint;
                                           zero_context: hb_bool_t): hb_bool_t
proc hb_ot_layout_lookup_substitute_closure*(face: ptr hb_face_t;
                                             lookup_index: cuint;
                                             glyphs: ptr hb_set_t)
proc hb_ot_layout_lookups_substitute_closure*(face: ptr hb_face_t;
                                              lookups: ptr hb_set_t;
                                              glyphs: ptr hb_set_t)
proc hb_ot_layout_has_positioning*(face: ptr hb_face_t): hb_bool_t
proc hb_ot_layout_get_size_params*(face: ptr hb_face_t;
                                   design_size: ptr cuint;
                                   subfamily_id: ptr cuint;
                                   subfamily_name_id: ptr hb_ot_name_id_t;
                                   range_start: ptr cuint;
                                   range_end: ptr cuint): hb_bool_t
proc hb_ot_layout_lookup_get_optical_bound*(font: ptr hb_font_t;
                                            lookup_index: cuint;
                                            direction: hb_direction_t;
                                            glyph: hb_codepoint_t): hb_position_t
proc hb_ot_layout_feature_get_name_ids*(face: ptr hb_face_t;
                                        table_tag: hb_tag_t;
                                        feature_index: cuint;
                                        label_id: ptr hb_ot_name_id_t;
                                        tooltip_id: ptr hb_ot_name_id_t;
                                        sample_id: ptr hb_ot_name_id_t;
                                        num_named_parameters: ptr cuint;
                                        first_param_id: ptr hb_ot_name_id_t): hb_bool_t
proc hb_ot_layout_feature_get_characters*(face: ptr hb_face_t;
                                          table_tag: hb_tag_t;
                                          feature_index: cuint;
                                          start_offset: cuint;
                                          char_count: ptr cuint;
                                          characters: ptr hb_codepoint_t): cuint
proc hb_ot_layout_get_font_extents*(font: ptr hb_font_t;
                                    direction: hb_direction_t;
                                    script_tag: hb_tag_t;
                                    language_tag: hb_tag_t;
                                    extents: ptr hb_font_extents_t): hb_bool_t
proc hb_ot_layout_get_font_extents2*(font: ptr hb_font_t;
                                     direction: hb_direction_t;
                                     script: hb_script_t;
                                     language: hb_language_t;
                                     extents: ptr hb_font_extents_t): hb_bool_t
proc hb_ot_layout_get_horizontal_baseline_tag_for_script*(
    script: hb_script_t): hb_ot_layout_baseline_tag_t
proc hb_ot_layout_get_baseline*(font: ptr hb_font_t;
                                baseline_tag: hb_ot_layout_baseline_tag_t;
                                direction: hb_direction_t;
                                script_tag: hb_tag_t; language_tag: hb_tag_t;
                                coord: ptr hb_position_t): hb_bool_t
proc hb_ot_layout_get_baseline2*(font: ptr hb_font_t;
                                 baseline_tag: hb_ot_layout_baseline_tag_t;
                                 direction: hb_direction_t;
                                 script: hb_script_t; language: hb_language_t;
                                 coord: ptr hb_position_t): hb_bool_t
proc hb_ot_layout_get_baseline_with_fallback*(
    font: ptr hb_font_t; baseline_tag: hb_ot_layout_baseline_tag_t;
    direction: hb_direction_t; script_tag: hb_tag_t; language_tag: hb_tag_t;
    coord: ptr hb_position_t)
proc hb_ot_layout_get_baseline_with_fallback2*(
    font: ptr hb_font_t; baseline_tag: hb_ot_layout_baseline_tag_t;
    direction: hb_direction_t; script: hb_script_t; language: hb_language_t;
    coord: ptr hb_position_t)

{.pop.}
