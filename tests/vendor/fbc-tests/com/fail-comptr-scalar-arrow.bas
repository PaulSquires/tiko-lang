' TEST_MODE : COMPILE_ONLY_FAIL

'' 'p->' where T is not a UDT is a compile error at the USE site, naming the
'' operator rather than the instantiation.  Mirrors
'' generics/fail-sharedptr-scalar-arrow.bas.

#include once "fb/comptr.bi"
using FB

dim as ComPtr( of integer ) p
print p->v
