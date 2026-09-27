'' The first file: a macro of its own, a header's, and the hermetic predefines.
#module "greet"
#include once "hdr.bi"
#define LOCALM 5
#if __FB_OUT_OBJ__ = -1
print "out-obj"
#endif
print "mod=" & __TKO_MODULE__
#ifdef CMDDEF
print "cmddef-leaked"
#endif
'' Undefining the header's macro is this file's own act, and is undone at its end too.
#undef HMAC
