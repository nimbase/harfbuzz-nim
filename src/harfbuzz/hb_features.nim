# Nim bindings to HarfBuzz text shaping engine
#
# (c) 2026 George Lemon | MIT License
#          https://github.com/nimbase/harfbuzz-nim 

## Bindings for hb-features.h (HarfBuzz 14.2.1).
##
## Build-time feature detection for this library build
## (MacPorts HarfBuzz 14.2.1). False means the feature was compiled out
## of this build, not that the binding is missing.

const
  HB_HAS_CAIRO* = true
  HB_HAS_CORETEXT* = true
  HB_HAS_DIRECTWRITE* = false
  HB_HAS_FREETYPE* = true
  HB_HAS_GDI* = false
  HB_HAS_GLIB* = true
  HB_HAS_GOBJECT* = true
  HB_HAS_GRAPHITE* = false
  HB_HAS_GPU* = false
  HB_HAS_ICU* = false
  HB_HAS_RASTER* = true
  HB_HAS_SUBSET* = true
  HB_HAS_UNISCRIBE* = false
  HB_HAS_VECTOR* = true
  HB_HAS_WASM* = false
