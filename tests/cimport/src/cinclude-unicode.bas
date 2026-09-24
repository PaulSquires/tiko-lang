'' '#define UNICODE' before '#cinclude' is UNICODE to clang too -- how windows.bi has
'' always been driven -- and the FreeBASIC-side macro does not collide with the header.
#define UNICODE
#cinclude "tests/cimport/src/ci/unicode.h"
dim as long which = CI_WHICH
print which
