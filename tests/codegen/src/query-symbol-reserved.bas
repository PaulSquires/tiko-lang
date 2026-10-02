'' A name '#pragma reserve' took, asked about by __FB_QUERY_SYMBOL__: fbc-modern prints 16 16.
#include once "fbc-int/symbol.bi"
#pragma reserve SYM_RESERVED
dim as integer r = __FB_QUERY_SYMBOL__( fbc.FB_QUERY_SYMBOL.symbclass, SYM_RESERVED )
print r; fbc.FB_SYMBCLASS_RESERVED
