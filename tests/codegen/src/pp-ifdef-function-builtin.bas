#ifdef __FUNCTION_NQ__
print "fnq defined"
#else
print "fnq undefined"
#endif
#ifdef __FUNCTION__
print "fn defined"
#endif
#ifdef __LINE__
print "line defined"
#endif
#ifdef __FILE_NQ__
print "filenq defined"
#endif
#ifdef __PATH__
print "path defined"
#endif
#if defined( __FUNCTION_NQ__ )
print "defined() yes"
#endif
