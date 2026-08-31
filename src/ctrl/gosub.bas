'' gosub.bas -- GOSUB / RETURN. Four entry points over one fbc member.
''
'' A GOSUB return address is a jmp_buf, and the stack of them is a plain
'' singly-linked list in malloc'd nodes. The compiler owns the head: it
'' allocates a pointer-sized GOSUBCTX in auto-local storage and is expected to
'' have zeroed it. There is no constructor, so a non-zero uninitialised ctx
'' would be followed as a node -- that contract belongs to the compiler, and
'' this side simply trusts it.
''
'' malloc AND free, NOT fb_MemAlloc. These nodes never pass through the
'' runtime's own allocator, so they are invisible to any allocation-count
'' differential. Routing them through fb_MemAlloc would be tidier and would
'' change what those tests measure.
''
'' fb_GosubReturn COPIES THE jmp_buf TO THE STACK BEFORE FREEING THE NODE.
'' longjmp reads the buffer, so jumping straight out of the node would read
'' freed memory -- reliably, since the read happens after the free and the
'' allocator may already have reused the block. fbc marks the copy as a TODO;
'' it is not optional under this allocation strategy.
''
'' THE THREE FAILURE PATHS ALL RETURN AN ERROR NUMBER RATHER THAN THROWING.
'' RETURN without GOSUB sets FB_RTERROR_RETURNWITHOUTGOSUB (16 -- the enum
'' index, not a BASIC ERR code) and returns normally. fb_GosubReturn only
'' returns at all in that case: on success it never comes back.

#include once "inc/rterror.bi"
#include once "crt/setjmp.bi"
#include once "crt/stdlib.bi"
#include once "crt/string.bi"

type GOSUBNODE
	as jmp_buf          buf
	as GOSUBNODE ptr    nxt
end type

'' Pointer-sized, and the compiler may allocate MORE than this -- fb_gosub.h
'' notes GOSUBCTX is an ANY PTR on the compiler side and can be extended.
'' Never assume sizeof( GOSUBCTX ) is the allocation.
type GOSUBCTX
	as GOSUBNODE ptr    top
end type

extern "rtlib"

declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval errnum as long ) as long

'' Pushes a node and hands back the address of ITS jmp_buf, for the caller to
'' setjmp into. The return value is the buffer, not the node.
function tkort_GosubPush alias "fb_GosubPush" ( byval ctx as GOSUBCTX ptr ) as any ptr
	dim as GOSUBNODE ptr node = malloc( sizeof( GOSUBNODE ) )
	node->nxt = ctx->top
	ctx->top = node
	return @(ctx->top->buf)
end function

'' Discards the top return address without jumping -- RETURN's bookkeeping when
'' the jump is not wanted.
function tkort_GosubPop alias "fb_GosubPop" ( byval ctx as GOSUBCTX ptr ) as long
	if( ctx <> 0 ) then
		if( ctx->top <> 0 ) then
			dim as GOSUBNODE ptr node = ctx->top->nxt
			free( ctx->top )
			ctx->top = node
			return tkrt_ErrorSetNum( FB_RTERROR_OK )
		end if
	end if
	return tkrt_ErrorSetNum( FB_RTERROR_RETURNWITHOUTGOSUB )
end function

'' Pops and jumps. DOES NOT RETURN on success.
function tkort_GosubReturn alias "fb_GosubReturn" ( byval ctx as GOSUBCTX ptr ) as long
	if( ctx <> 0 ) then
		if( ctx->top <> 0 ) then
			dim as GOSUBNODE ptr node = ctx->top->nxt
			'' The copy is load-bearing: longjmp reads the buffer, and the
			'' node is freed first, so jumping out of the node itself would
			'' read memory the allocator may already have handed back out.
			'' fbc marks the copy a TODO; under this allocation strategy it
			'' is not optional.
			''
			'' THE COPY IS HAND-ALIGNED TO 16, AND THIS IS NOT DEFENSIVE.
			'' mingw-w64's x64 setjmp/longjmp save and restore xmm6-xmm15 with
			'' MOVAPS, which faults on a misaligned address, and C's jmp_buf
			'' carries __attribute__((aligned(16))) for exactly that reason.
			'' FreeBASIC's crt/setjmp.bi declares jmp_buf as a plain UDT with no
			'' alignment attribute, so a `dim as jmp_buf` local gets whatever the
			'' frame layout gives it.
			''
			'' MEASURED, TWICE, AND THE FIRST MEASUREMENT WAS WRONG. An earlier
			'' version aligned this by hand, then removed the alignment after a
			'' probe reported the local was already 16-aligned -- a probe built
			'' in DEBUG. In Release the disassembly says otherwise:
			''
			''     Debug    subq $0x138,%rsp ; leaq 0x20(%rsp)  -> 16-aligned
			''     Release  4 pushes + subq $0x128,%rsp ; leaq 0x28(%rsp) -> 8
			''
			'' so gosub-parity passed in Debug and SEGFAULTED in Release. Adding a
			'' trace to find out why moved the frame and made it pass -- which is
			'' what a codegen-alignment bug looks like from the outside, and why
			'' the answer had to come from objdump rather than from a printf.
			''
			'' The SOURCE needs no such care: it lives at offset 0 of a malloc'd
			'' node, and malloc is 16-aligned on every target here.
			dim as ubyte raw( 0 to sizeof( jmp_buf ) + 15 ) = any
			dim as uinteger a = cast( uinteger, @raw(0) )
			a = (a + 15) and (not cast( uinteger, 15 ))
			dim as jmp_buf ptr buf = cptr( jmp_buf ptr, a )

			memcpy( buf, @ctx->top->buf, sizeof( jmp_buf ) )
			free( ctx->top )
			ctx->top = node
			longjmp( buf, -1 )
		end if
	end if
	return tkrt_ErrorSetNum( FB_RTERROR_RETURNWITHOUTGOSUB )
end function

'' Scope exit: drop every pending return address. A GOSUB whose RETURN never
'' ran leaves nodes behind, and this is the only thing that frees them.
sub tkort_GosubExit alias "fb_GosubExit" ( byval ctx as GOSUBCTX ptr )
	if( ctx <> 0 ) then
		while( ctx->top <> 0 )
			dim as GOSUBNODE ptr node = ctx->top->nxt
			free( ctx->top )
			ctx->top = node
		wend
	end if
end sub

end extern
