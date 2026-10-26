/* Nim's cstring has no const qualifier. Preserve the existing Nim API while
 * adapting the few const pointer/callback boundaries for C++ and MSVC. */
#ifndef HARFBUZZ_NIM_NATIVE_STATIC_H
#define HARFBUZZ_NIM_NATIVE_STATIC_H
#include <harfbuzz/hb.h>
#include <harfbuzz/hb-ot.h>

#define hb_ot_name_list_names(face, count) \
  ((hb_ot_name_entry_t *) hb_ot_name_list_names(face, count))
#define hb_buffer_deserialize_glyphs(buffer, text, len, end, font, format) \
  hb_buffer_deserialize_glyphs(buffer, text, len, (const char **) (end), font, format)
#define hb_buffer_deserialize_unicode(buffer, text, len, end, format) \
  hb_buffer_deserialize_unicode(buffer, text, len, (const char **) (end), format)
#define hb_buffer_set_message_func(buffer, callback, data, destroy) \
  hb_buffer_set_message_func(buffer, (hb_buffer_message_func_t) (callback), data, destroy)

/* Borrowed string/list results stay read-only despite Nim's unqualified
 * cstring types. Inline adapters also work when APIs are used as values. */
static inline char *harfbuzz_nim_version_string(void)
{ return (char *) hb_version_string(); }
static inline char *harfbuzz_nim_direction_to_string(hb_direction_t direction)
{ return (char *) hb_direction_to_string(direction); }
static inline char *harfbuzz_nim_language_to_string(hb_language_t language)
{ return (char *) hb_language_to_string(language); }
static inline char *harfbuzz_nim_blob_get_data(hb_blob_t *blob, unsigned int *length)
{ return (char *) hb_blob_get_data(blob, length); }
static inline char *harfbuzz_nim_shape_plan_get_shaper(hb_shape_plan_t *plan)
{ return (char *) hb_shape_plan_get_shaper(plan); }
static inline char *harfbuzz_nim_buffer_serialize_format_to_string(hb_buffer_serialize_format_t format)
{ return (char *) hb_buffer_serialize_format_to_string(format); }
static inline char **harfbuzz_nim_shape_list_shapers(void)
{ return (char **) hb_shape_list_shapers(); }
static inline char **harfbuzz_nim_buffer_serialize_list_formats(void)
{ return (char **) hb_buffer_serialize_list_formats(); }

static inline hb_bool_t
harfbuzz_nim_shape_full(hb_font_t *font, hb_buffer_t *buffer,
                       hb_feature_t *features, unsigned int count, char **shapers)
{ return hb_shape_full(font, buffer, features, count, (const char *const *) shapers); }
static inline hb_shape_plan_t *
harfbuzz_nim_shape_plan_create(hb_face_t *face, hb_segment_properties_t *props,
                              hb_feature_t *features, unsigned int count, char **shapers)
{ return hb_shape_plan_create(face, props, features, count, (const char *const *) shapers); }
static inline hb_shape_plan_t *
harfbuzz_nim_shape_plan_create_cached(hb_face_t *face, hb_segment_properties_t *props,
                                     hb_feature_t *features, unsigned int count, char **shapers)
{ return hb_shape_plan_create_cached(face, props, features, count, (const char *const *) shapers); }
static inline hb_shape_plan_t *
harfbuzz_nim_shape_plan_create2(hb_face_t *face, hb_segment_properties_t *props,
                               hb_feature_t *features, unsigned int count,
                               int *coords, unsigned int coord_count, char **shapers)
{ return hb_shape_plan_create2(face, props, features, count, coords, coord_count,
                               (const char *const *) shapers); }
static inline hb_shape_plan_t *
harfbuzz_nim_shape_plan_create_cached2(hb_face_t *face, hb_segment_properties_t *props,
                                      hb_feature_t *features, unsigned int count,
                                      int *coords, unsigned int coord_count, char **shapers)
{ return hb_shape_plan_create_cached2(face, props, features, count, coords, coord_count,
                                      (const char *const *) shapers); }

/* Object-like aliases preserve these qualifiers when taking API addresses. */
#define hb_version_string harfbuzz_nim_version_string
#define hb_direction_to_string harfbuzz_nim_direction_to_string
#define hb_language_to_string harfbuzz_nim_language_to_string
#define hb_blob_get_data harfbuzz_nim_blob_get_data
#define hb_shape_plan_get_shaper harfbuzz_nim_shape_plan_get_shaper
#define hb_buffer_serialize_format_to_string harfbuzz_nim_buffer_serialize_format_to_string
#define hb_shape_list_shapers harfbuzz_nim_shape_list_shapers
#define hb_buffer_serialize_list_formats harfbuzz_nim_buffer_serialize_list_formats
#define hb_shape_full harfbuzz_nim_shape_full
#define hb_shape_plan_create harfbuzz_nim_shape_plan_create
#define hb_shape_plan_create_cached harfbuzz_nim_shape_plan_create_cached
#define hb_shape_plan_create2 harfbuzz_nim_shape_plan_create2
#define hb_shape_plan_create_cached2 harfbuzz_nim_shape_plan_create_cached2
#endif
