'' --print-cincludes: two #cinclude lines (the second a delta), a repeat, one in an
'' included file found beside that file, and one that cannot be imported.
#cinclude "tests/cimport/src/ci/a.h"
#cinclude "tests/cimport/src/ci/b.h"
#cinclude "tests/cimport/src/ci/a.h"
#include "printcinc.bi"
#cinclude "tests/cimport/src/ci/no-such-header.h"
