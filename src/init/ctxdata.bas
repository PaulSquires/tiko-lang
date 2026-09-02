'' ctxdata.bas -- __fb_ctx, and nothing else. One data symbol.
''
'' THE RUNTIME CONTEXT ITSELF: the struct every other member of the archive
'' reaches through. fbc's own members compute their field offsets at compile
'' time and index into this block, so what tiko-rt owes is the SIZE and the
'' ALIGNMENT -- not the layout. Getting the interior "right" is not something
'' this file can even attempt, because the interior is decided by fbc's headers
'' and is already baked into every member that is still fbc's.
''
'' THE SIZE IS READ OFF fbc's OWN BSS SYMBOL, not derived from the header:
''
''     nm -S init.o   ->   win64 0x5188 = 20872
''                         win32 0x40e8 = 16616
''                         linux 0x5188 = 20872
''
'' Deriving it would mean modelling FB_FILE, FB_HOOKSTB, FBSTRING and FBUSTRING
'' exactly and trusting every one -- twelve chances to be wrong about padding for
'' a number the linker already knows. inc/config.bi carries it as
'' TKORT_CTX_SIZE with that derivation written down.
''
'' EIGHT-BYTE ALIGNMENT, AND THAT IS THE CONTRACT DESPITE fbc ASKING FOR 32.
'' fbc's object requests 2**5 alignment for the .bss section holding this. But
'' 20872 is not a multiple of 32, and a struct whose alignment were 32 would have
'' been padded up to one -- so the 32 is gcc over-aligning a large static object
'' for cache reasons, not a requirement of the type. The real alignment is 8, set
'' by the pointers and doubles inside, and FreeBASIC cannot over-align a symbol
'' anyway. Declaring the block as an array of LONGINT gets exactly 8, and both
'' sizes are exact multiples of 8 (2609 and 2077 elements) so nothing is rounded.
''
'' A `dim shared` INSIDE `extern "c"` WOULD BE FILE-LOCAL, and this file exists
'' because of that. __fb_errmsg was written that way once: it compiled, linked
'' and gated green while emitting a lowercase `b`, so tiko-rt kept an UNDEFINED
'' reference and fbc's member quietly supplied the real one. The idiom that
'' works is DECLARE `extern ... alias` inside the block, then DEFINE with a plain
'' `dim shared` OUTSIDE it.
''
'' AND IT MUST NOT SEE inc/ctx.bi, which declares the same C name twice at two
'' different FreeBASIC types -- `__fb_ctx as TKORT_CTX_HEAD` (a deliberately
'' PARTIAL struct that stops at unull_desc) and `__fb_ctx_head as ubyte`. Either
'' one alongside the full-size declaration below is error 4. That is the same
'' reason error/errmsg.bas is a file of its own, and it is why the size constant
'' lives in inc/config.bi rather than in inc/ctx.bi.

#include once "inc/config.bi"

'' LONGINT, so the element alignment IS the alignment -- see the file header.
type TKORT_CTX_BLOCK
	as longint v( 0 to (TKORT_CTX_SIZE \ 8) - 1 )
end type

'' The two things that must hold, checked rather than trusted: the block is
'' exactly fbc's size, and the size divided evenly by 8 in the first place.
#assert sizeof( TKORT_CTX_BLOCK ) = TKORT_CTX_SIZE
#assert (TKORT_CTX_SIZE mod 8) = 0

extern "c"   '' NON-FBCALL: __fb_ctx is DATA. FBCALL decorates call sites; a data
             '' symbol carries no @N on win32 and must not be declared as though
             '' it did. The declaration is also what gives the definition below
             '' EXTERNAL linkage.
	extern __fb_ctx alias "__fb_ctx" as TKORT_CTX_BLOCK
end extern

'' OUTSIDE the block, deliberately. See the file header.
dim shared __fb_ctx as TKORT_CTX_BLOCK
