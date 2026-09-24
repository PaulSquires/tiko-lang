'' opaque1.h leaves struct ci_opq opaque and opaque2.h defines it: two types for one C
'' struct, refused with the order that works.
#cinclude "tests/cimport/src/ci/opaque1.h"
#cinclude "tests/cimport/src/ci/opaque2.h"
