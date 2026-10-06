print "[" & __FB_QUOTE__( __FB_UNIQUEID__( k ) ) & "]"
__FB_UNIQUEID_PUSH__( k )
print len( __FB_QUOTE__( __FB_UNIQUEID__( k ) ) ) > 0
__FB_UNIQUEID_POP__( k )
print "[" & __FB_QUOTE__( __FB_UNIQUEID__( k ) ) & "]"
