' TEST_MODE : COMPILE_ONLY_FAIL

'' ComInit is non-copyable, and it is ENFORCED rather than merely documented.
''
'' RFC-0004 §1 and RFC-0005 §13 originally said this could not be prevented,
'' because FreeBASIC has no '= delete'.  It can: a copy constructor declared in a
'' PRIVATE section makes the copy 'error 205: Constructor has no public access'.
'' A copy would call CoUninitialize once per copy and unbalance the apartment.

#include once "fb/comptr.bi"
using FB

dim as ComInit a
dim as ComInit b = a
