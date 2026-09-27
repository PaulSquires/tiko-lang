'' The second file: the first file's macro is gone and the header's is back.
#module "greet"
#include once "hdr.bi"
#ifdef LOCALM
print "localm-leaked"
#endif
#ifdef HMAC
print "hmac-kept"
#endif
