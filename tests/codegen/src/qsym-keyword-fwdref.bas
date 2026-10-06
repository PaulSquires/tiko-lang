'' __FB_QUERY_SYMBOL__ symbclass: a keyword is KEYWORD, a name only forward-referenced is FWDREF
#include "fbc-int/symbol.bi"
type FWDREF as SYM_FWDREF
print __FB_QUERY_SYMBOL__( fbc.FB_QUERY_SYMBOL.symbclass, integer )
print __FB_QUERY_SYMBOL__( fbc.FB_QUERY_SYMBOL.symbclass, SYM_FWDREF )
print __FB_QUERY_SYMBOL__( fbc.FB_QUERY_SYMBOL.symbclass, string )
print __FB_QUERY_SYMBOL__( fbc.FB_QUERY_SYMBOL.symbclass, print )
