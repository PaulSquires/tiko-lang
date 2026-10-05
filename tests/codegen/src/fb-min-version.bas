print __FB_VERSION__, __FB_VER_MAJOR__, __FB_VER_MINOR__, __FB_VER_PATCH__
print __FB_MIN_VERSION__( 1, 10, 0 )
print __FB_MIN_VERSION__( 1, 20, 0 )
print __FB_MIN_VERSION__( 1, 20, 1 )
print __FB_MIN_VERSION__( 2, 0, 0 )
print __FB_MIN_VERSION__( 0, 99, 99 )
#if __FB_MIN_VERSION__( 1, 9, 0 )
print "pp yes"
#endif
#if __FB_MIN_VERSION__( 1, 30, 0 )
print "pp no?"
#endif
