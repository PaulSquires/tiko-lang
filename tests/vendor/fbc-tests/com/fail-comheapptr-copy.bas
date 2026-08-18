' TEST_MODE : COMPILE_ONLY_FAIL

'' ComHeapPtr is non-copyable, and enforced the same way ComInit is.
''
'' A heap block has exactly one owner and there is no refcount to share it with,
'' so a copy would be a double free.  Detach transfers; nothing copies.

#include once "fb/comptr.bi"
using FB

dim as ComHeapPtr( of ushort ) a
dim as ComHeapPtr( of ushort ) b
b = a
