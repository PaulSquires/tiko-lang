'' errmsg.bas -- __fb_errmsg, and nothing else. One data symbol, one fbc member.
''
'' A FILE OF ITS OWN BECAUSE OF A DECLARATION CLASH, not because one symbol
'' deserves a module. inc/ctx.bi carries
''
''     extern __fb_errmsg alias "__fb_errmsg" as ubyte
''
'' so every module that reaches the runtime context already has the name
'' declared -- and a module that both DECLARES and DEFINES it is
'' `error 4: Duplicated definition`. This file includes only inc/config.bi,
'' which is where FB_ERRMSG_SIZE lives, and therefore never sees the extern.
''
'' AND THE DEFINITION CARRIES NO `alias`. `dim shared X alias "Y"` is error 147,
'' whose message ("Default types or suffixes are only valid in -lang
'' deprecated") names neither the keyword nor the reason. Inside an `extern "c"`
'' block the FreeBASIC name IS the C name, so the alias would have been
'' redundant even if it had parsed.
''
'' 1024 BYTES, ZEROED. fbc writes `char __fb_errmsg[FB_ERRMSG_SIZE] = ""`, which
'' in C zeroes the WHOLE array rather than just the first byte -- and fb_Assert
'' formats into it with snprintf, which relies on nothing but the size.
''
'' fb_Die and fb_Assert reach it through their own extern declarations, and
'' __fb_ctx.errmsg is what publishes the pointer to the error handler.

#include once "inc/config.bi"

extern "c"   '' NON-FBCALL: __fb_errmsg is DATA, not a procedure.
	dim shared __fb_errmsg as zstring * FB_ERRMSG_SIZE
end extern
