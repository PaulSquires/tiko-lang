'' The intrinsic defines T96 added, with the values fbc-modern gives them.
print __FB_VER_MAJOR__; __FB_VER_MINOR__; __FB_VER_PATCH__
print __FB_GUI__; __FB_OPTIMIZE__; __FB_PROFILE__; __FB_VECTORIZE__
print __FB_BUILD_FORK_ID__; len( __FB_BUILD_DATE__ ); len( __FB_BUILD_DATE_ISO__ ); len( __FB_BUILD_SHA1__ )
#ifdef __FB_MAIN__
print "main"
#endif
print __FB_ARGC__; ( *__FB_ARGV__[0] <> "" )
