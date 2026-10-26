## Headers for opaque C types and static C qualifier adapters.
import std/os

const hbNativeHeader* = currentSourcePath().parentDir / "native_static.h"
const hbOpaqueHeader* = currentSourcePath().parentDir / "opaque_types.h"
