## Opaque language pointers must share their C tag across callback prototypes.
## Import only the common types so hb.h cannot supply the forward declaration.
import harfbuzz/hb_common

type LanguageToString = proc(language: hb_language_t): cstring {.cdecl.}

proc callLanguage(toString: LanguageToString, language: hb_language_t): cstring =
  toString(language)

proc languageName(language: hb_language_t): cstring {.cdecl.} =
  "language"

let function: LanguageToString = languageName
doAssert $callLanguage(function, nil) == "language"
