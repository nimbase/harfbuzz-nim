## Bindings for hb-subset-serialize.h (HarfBuzz 14.2.1).
##
## Links -lharfbuzz-subset (same library as hb_subset).

import harfbuzz/hb_common
import harfbuzz/hb_blob

export hb_common
export hb_blob

type
  hb_subset_serialize_link_t* = object
    width*: cuint
    position*: cuint
    objidx*: cuint

  hb_subset_serialize_object_t* = object
    head*: cstring
    tail*: cstring
    num_real_links*: cuint
    real_links*: ptr hb_subset_serialize_link_t
    num_virtual_links*: cuint
    virtual_links*: ptr hb_subset_serialize_link_t

{.push header: "<harfbuzz/hb-subset.h>", importc, cdecl.}

proc hb_subset_serialize_or_fail*(table_tag: hb_tag_t;
                                  hb_objects: ptr hb_subset_serialize_object_t;
                                  num_hb_objs: cuint): ptr hb_blob_t

{.pop.}
