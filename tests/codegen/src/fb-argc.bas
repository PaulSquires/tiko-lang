'' T80: __FB_ARGC__ and __FB_ARGV__ are main's parameters, readable at module level:
'' a LONG and a ZSTRING PTR PTR, as fbc declares them. Run with no arguments.
dim as long n = __FB_ARGC__
print n
dim as string self_ = lcase( *__FB_ARGV__[0] )
print instr( self_, "fbargc" ) > 0
