'' See ../field-named-function.test.
#include once "field-named-function-a.bi"
#define KEEP_ME 21
#include once "field-named-function-b.bi"
#ifndef KEEP_ME
#error "KEEP_ME was dropped"
#endif
dim as AuxSymbol a
a.Function = KEEP_ME
print Twice( a.Function )
