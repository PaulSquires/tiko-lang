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

'' ================================================== __fb_ctx.errmsg
''
'' fb_hRtExit prints this on the way out, so the error and assert paths have to
'' set it -- and it is the field AFTER unull_desc, which the struct above
'' deliberately stops at.
''
'' MEASURED, INCLUDING ON win32, BY READING fbc's OWN COMPILED CODE.
''
'' The C probe against fbc's headers gives the 64-bit targets directly, but no
'' 32-bit MinGW headers are available here, and the runtime scan that located
'' fileTB cannot work for this field: errmsg is NULL until an assert fires, so
'' there is nothing to search for.
''
'' fbc's own win32 object encodes it. Disassembling error_assert.o:
''
''     45: c7 05 20 00 00 00 ...   movl $0x0, 0x20
''     00000047: IMAGE_REL_I386_DIR32  ___fb_ctx
''
'' -- a store to __fb_ctx + 0x20, so errmsg is at 32.
''
'' THE METHOD WAS VALIDATED AGAINST A KNOWN ANSWER FIRST. The same disassembly
'' applied to file_free.o gives `addl $0x98, %eax` against ___fb_ctx -- 152 --
'' which is exactly what the runtime scan had already established for fileTB.
'' Its `shll $0x6` also confirms sizeof( FB_FILE ) = 64 on win32 independently.
'' A technique that has not reproduced something already known is not a
'' measurement.
#if defined( __FB_64BIT__ )
	const TKORT_ERRMSG_OFFSET = 64
#else
	const TKORT_ERRMSG_OFFSET = 32
#endif

extern "c"   '' NON-FBCALL: both are DATA.
	extern __fb_ctx_head alias "__fb_ctx" as ubyte
	'' The 1024-byte buffer fbc formats its message into. Shared, not ours.
	extern __fb_errmsg alias "__fb_errmsg" as ubyte
end extern

const FB_ERRMSG_SIZE = 1024

'' The slot fb_hRtExit reads. Writing it is how a runtime error's text reaches
'' the exit path.
#define TKORT_CTX_ERRMSG() *cptr( any ptr ptr, @__fb_ctx_head + TKORT_ERRMSG_OFFSET )

'' ================================================== __fb_ctx.hooks
''
'' The redirectable console operations. gfxlib installs its own here so that
'' PRINT inside a graphics window goes to the window rather than the console;
'' when a slot is NULL the console implementation runs instead.
''
'' ONLY THE TWO PRINT SLOTS ARE BOUND, by offset rather than as a struct. The
'' table has twenty-seven function pointers and binding all of them would be
'' twenty-five more chances to get a layout wrong for no benefit -- the same
'' reasoning that stops TKORT_CTX_HEAD at unull_desc.
''
'' MEASURED, both ways. The C probe gives the 64-bit targets: hooks at ctx+72,
'' printbuffproc at hooks+88, so ctx+160 and ctx+168. win32 comes from fbc's own
'' compiled objects, the technique validated on fileTB:
''
''     hook_printstr.o    movl 0x50, %eax   rel ___fb_ctx  ->  80
''     hook_print_wstr.o  movl 0x54, %eax   rel ___fb_ctx  ->  84
#if defined( __FB_64BIT__ )
	const TKORT_HOOK_PRINTBUFF  = 160
	const TKORT_HOOK_PRINTBUFFW = 168
#else
	const TKORT_HOOK_PRINTBUFF  = 80
	const TKORT_HOOK_PRINTBUFFW = 84
#endif

type FB_PRINTBUFFPROC as sub cdecl ( byval buffer as any ptr, byval length as uinteger, byval mask as long )
type FB_PRINTBUFFWPROC as sub cdecl ( byval buffer as wstring ptr, byval length as uinteger, byval mask as long )

#define TKORT_HOOK_PRINTBUFFPROC() _
	*cptr( FB_PRINTBUFFPROC ptr, @__fb_ctx_head + TKORT_HOOK_PRINTBUFF )
#define TKORT_HOOK_PRINTBUFFWPROC() _
	*cptr( FB_PRINTBUFFWPROC ptr, @__fb_ctx_head + TKORT_HOOK_PRINTBUFFW )

#endif '' __TKORT_CTX_BI__
