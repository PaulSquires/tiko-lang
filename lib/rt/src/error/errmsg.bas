'' errmsg.bas -- __fb_errmsg, and nothing else. One data symbol, one fbc member.
''
'' A `dim shared` INSIDE `extern "c"` IS NOT A GLOBAL DEFINITION. Written that
'' way this file compiled, linked and gated green while emitting a FILE-LOCAL
'' symbol -- `nm` showed lowercase `b`, not `B` -- so tiko-rt's archive still
'' carried an UNDEFINED reference to __fb_errmsg and fbc's error_message.o kept
'' supplying it. The gate passed because gate.sh deletes fbc's members by SYMBOL
'' and tiko-rt defined none; the differential passed because it was reading
'' fbc's buffer. Nothing anywhere said so.
''
'' THE IDIOM THAT WORKS is the one src/utf/core.bas already uses for its three
'' tables: DECLARE the name `extern ... alias` inside an `extern "c"` block, then
'' DEFINE it with a plain `dim shared` OUTSIDE that block. The declaration is
'' what gives the definition external linkage; the alias is what gives it the C
'' name. `dim shared X alias "Y"` is error 147 and is not the answer.
''
'' AND THE MODULE MUST NOT ALSO SEE inc/ctx.bi, which carries its own
'' `extern __fb_errmsg alias "__fb_errmsg" as ubyte` -- two declarations of the
'' same name at different types is error 4. That is why this is a file of its
'' own including only inc/config.bi, and why the type below is declared here
'' rather than shared.
''
'' 1024 BYTES, ZEROED. fbc writes `char __fb_errmsg[FB_ERRMSG_SIZE] = ""`, which
'' in C zeroes the WHOLE array rather than just the first byte -- and BSS gives
'' the same thing without an initialiser. fb_Assert formats into it with
'' snprintf, which relies on nothing but the size.
''
'' fb_Die and fb_Assert reach it through their own extern declarations, and
'' __fb_ctx.errmsg is what publishes the pointer to the error handler.

#include once "inc/config.bi"

type TKORT_ERRMSG_BUF
	as ubyte v( 0 to FB_ERRMSG_SIZE - 1 )
end type

extern "c"   '' NON-FBCALL: __fb_errmsg is DATA, not a procedure. The
             '' declaration is what makes the definition below external.
	extern __fb_errmsg alias "__fb_errmsg" as TKORT_ERRMSG_BUF
end extern

dim shared __fb_errmsg as TKORT_ERRMSG_BUF
