#ifndef __TKORT_CTX_BI__
#define __TKORT_CTX_BI__

'' ctx.bi -- the head of fbc's global runtime context, and the shared empty
'' string that lives in it.
''
'' WHY THIS EXISTS. Every string entry point that can answer "nothing" answers
'' with the SAME descriptor: `&__fb_ctx.null_desc`. Measured (PROBE-32):
''
''     TRIM("  ")  and  LEFT("  ",0)  return one pointer, not two
''
'' slice.bas originally kept a private empty of its own. It had the right
'' CONTENTS -- len 0, size 0, data NULL, temp bit clear -- and passed every gate,
'' because nothing in fbc's 2,715-file suite compares two empty results by
'' address. It was still wrong, and the kind of wrong this project keeps finding:
'' a divergence that no test happens to look at yet.
''
'' ONLY THE HEAD IS DECLARED. The real FB_RTLIB_CTX continues with errmsg, the
'' hook table and FB_MAX_FILES worth of FB_FILE -- thousands of bytes whose
'' layout tiko-rt does not need and must not guess. Taking the address of
'' null_desc needs the fields BEFORE it and nothing after, so that is all that is
'' written down. The object itself is DEFINED by fbc's runtime; this is a
'' reference to it, never a definition, and the truncation is therefore invisible
'' to the linker.
''
'' The offsets are fbc's own layout rules applied to the same field types, so
'' they follow the target automatically. Verified anyway, because "it should
'' follow automatically" is how the wchar_t traps in this workspace began:
''
''     win64  argc 0  argv 8  null_desc 16      (PROBE-32)
''     win32  argc 0  argv 4  null_desc  8      (PROBE-32)
''
'' Source: fb.h's FB_RTLIB_CTX declaration. No .c body was opened.

#include once "inc/descriptors.bi"

'' NO `field = 1` HERE. Every other type in this project is byte-packed because
'' it mirrors a struct fbc lays out itself; this one mirrors a C struct that the
'' C COMPILER laid out, with natural alignment. Packing it put argv at offset 4
'' on win64 instead of 8 and null_desc at 12 instead of 16 -- so TKORT_NULLSTR
'' returned a pointer into the MIDDLE of the descriptor, straddling argv and
'' null_desc.data. It compiled, linked and returned a plausible empty string.
'' build/diff.sh caught it on its first run.
type TKORT_CTX_HEAD
	as long             argc       '' C int
	as zstring ptr ptr  argv
	as FBSTRING         null_desc
	as FBUSTRING        unull_desc   '' the ustring family's shared empty
	'' ... errmsg, hooks, fileTB, ... -- deliberately absent
end type

extern "c" '' NON-FBCALL -- __fb_ctx is DATA, not a procedure. FBCALL decorates
            '' call sites; a data symbol carries no @N on win32 and must not be
            '' declared as though it did.
	extern __fb_ctx alias "__fb_ctx" as TKORT_CTX_HEAD
end extern

'' The one empty string. Its temp bit is CLEAR, which is what stops a caller
'' freeing it -- returning an allocated empty temporary instead would be a leak
'' on every degenerate call.
#define TKORT_NULLSTR() (@__fb_ctx.null_desc)

'' The ustring counterpart. Same rule: one shared empty, temp bit clear, and
'' returning an allocated empty temporary instead would be a leak on every
'' degenerate call.
#define TKORT_UNULLSTR() (@__fb_ctx.unull_desc)

#endif '' __TKORT_CTX_BI__
