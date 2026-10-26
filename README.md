<p align="center">
  Nim bindings to HarfBuzz text shaping engine<br>
</p>

<p align="center">
  <code>nimble install harfbuzz</code>
</p>

<p align="center">
  <a href="https://nimbase.github.io/harfbuzz-nim/">API reference</a><br>
  <img src="https://github.com/nimbase/harfbuzz-nim/workflows/test/badge.svg" alt="Github Actions">  <img src="https://github.com/nimbase/harfbuzz-nim/workflows/docs/badge.svg" alt="Github Actions">
</p>


## Features
- Complete low-level HarfBuzz C API
- Covering shaping, buffers, fonts, faces, blobs, Unicode, OpenType layout/metrics/variations/color/math, AAT layout,
  subsetting, draw/paint callbacks, and the hb-icu glue
- C names kept verbatim with `importc`, so the HarfBuzz C documentation applies one to one
- Opaque HarfBuzz structs stay ABI identical, so callbacks (draw funcs, font funcs, unicode funcs, face table loaders) are plain Nim procs with no casts
- Links the system HarfBuzz through `pkg-config`; hb-icu support links ICU for script and Unicode data
- Tested against the real library: shaping, kerning, ligatures, RTL runs, subsets, serialization roundtrips, draw/paint tracing, and OT table queries

## Examples
Shape a run and print glyph ids with advances:
```nim
import harfbuzz

let blob = hb_blob_create_from_file_or_fail("DejaVuSans.ttf")
let face = hb_face_create(blob, 0)
hb_blob_destroy(blob)
let font = hb_font_create(face)
hb_ot_font_set_funcs(font)
let upem = hb_face_get_upem(face)
hb_font_set_scale(font, cint(upem), cint(upem))

let buf = hb_buffer_create()
let text = "AV fi"
hb_buffer_add_utf8(buf, text.cstring, cint(text.len), 0, cint(text.len))
hb_buffer_guess_segment_properties(buf)
hb_shape(font, buf, nil, 0)

var count: cuint = 0
let infos = cast[ptr UncheckedArray[hb_glyph_info_t]](
  hb_buffer_get_glyph_infos(buf, addr count))
let positions = cast[ptr UncheckedArray[hb_glyph_position_t]](
  hb_buffer_get_glyph_positions(buf, nil))
for i in 0 ..< int(count):
  echo infos[i].codepoint, " +", positions[i].x_advance

hb_buffer_destroy(buf)
hb_font_destroy(font)
hb_face_destroy(face)
```

Subset a face down to one codepoint:
```nim
let input = hb_subset_input_create_or_fail()
hb_set_add(hb_subset_input_unicode_set(input), 0x41) # keep "A"
let small = hb_subset_or_fail(face, input)
hb_subset_input_destroy(input)
# ... save hb_face_reference_blob(small) bytes, then hb_face_destroy(small)
```


### Static linking

Define `harfbuzzStatic` to use prebuilt static HarfBuzz libraries. This disables
all automatic `pkg-config` calls, including those for the subset and ICU modules.
Supply the compiler include paths, archive paths, and platform dependencies
yourself. The bindings use the same C API in both link modes; this option does
not download or build HarfBuzz.

For a Unix HarfBuzz installation built without optional dependencies:

```sh
nim c -r -d:harfbuzzStatic \
  --passC:-I/path/to/harfbuzz/include \
  --passC:-DHB_NO_SINGLE_HEADER_ERROR \
  --passL:/path/to/harfbuzz/lib/libharfbuzz-subset.a \
  --passL:/path/to/harfbuzz/lib/libharfbuzz.a \
  --passL:-pthread --passL:-lm tests/test_static_linking.nim
```

Use explicit archive paths to prevent the linker from selecting shared
libraries. Include `libharfbuzz-subset` before the core archive when using the
subset API. If you call ICU APIs, also supply the `libharfbuzz-icu` archive and
ICU's headers and libraries. Other native dependencies depend on how HarfBuzz
was built. On Windows, use the corresponding `.lib` paths and MSVC include flags.

Static mode preserves the native C typedef identities for opaque handles,
records, unions, and enums, so the same bindings also work with `nim cpp` and
MSVC's stricter type checking. This is selected only by `harfbuzzStatic`;
the default bindings retain their existing representation.

For caller-supplied shared-library flags or external loaders, define
`harfbuzzNoPkgConfig` to disable automatic `pkg-config` calls without enabling
native static type annotations. This leaves the existing C declarations intact.

### ❤ Contributions & Support
- 🐛 Found a bug? [Create a new Issue](https://github.com/nimbase/harfbuzz-nim/issues)
- 👋 Wanna help? [Fork it!](https://github.com/nimbase/harfbuzz-nim/fork)

### 🎩 License
MIT license | Nim Community.
