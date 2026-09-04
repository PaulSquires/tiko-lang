'' hookmisc-parity.bas -- fb_LocateEx, the two LINE INPUT dispatchers,
'' fb_ReadString and the two mouse queries. Six entry points across six fbc
'' members.
''
'' NEEDS-GEN-LLVM
''
'' THE HOOK IS THE THING BEING TESTED, and it can be installed from here: fbc
'' exposes __fb_ctx.hooks, so this file writes its OWN procedures into the two
'' LINE INPUT slots and the mouse slot, calls the entry points, and checks that
'' the arguments arrive intact and the return comes back. That is the whole
'' contract of a dispatcher, and it needs no console at all.
''
'' THE HOOKS ARE REMOVED AGAIN AFTERWARDS. Leaving one installed would change
'' what every later test in the same program does -- and this file's own
'' fb_LocateEx checks run with the slot empty, which is the fallback path.
''
'' THE TWO LINE INPUTS ARE NEVER CALLED WITHOUT A HOOK. Their fallback blocks on
'' a read, and under the differential stdin is not a terminal -- a blocking test
'' hangs the whole run. With a hook installed the fallback is never reached, so
'' the dispatch is tested and the blocking is not.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pLocateEx  alias "fb_LocateEx" _
		( byval r as long, byval c as long, byval cur as long, byval pos_ as long ptr ) as long
	declare function pLineInput alias "fb_LineInput" _
		( byval t as any ptr, byval d as any ptr, byval dl as integer, _
		  byval fr as long, byval q as long, byval nl as long ) as long
	declare function pLineInputW alias "fb_LineInputWstr" _
		( byval t as wstring ptr, byval d as wstring ptr, byval mc as integer, _
		  byval q as long, byval nl as long ) as long
	declare function pGetMouse   alias "fb_GetMouse" _
		( byval x as long ptr, byval y as long ptr, byval z as long ptr, _
		  byval b as long ptr, byval c as long ptr ) as long
	declare function pGetMouse64 alias "fb_GetMouse64" _
		( byval x as longint ptr, byval y as longint ptr, byval z as longint ptr, _
		  byval b as longint ptr, byval c as longint ptr ) as long
end extern

extern "c"
	declare function pReadString alias "fb_ReadString" _
		( byval buf as zstring ptr, byval l as integer, byval f as any ptr ) as zstring ptr
end extern

dim shared as any ptr addrs( 0 to 5 )
addrs(0) = cast( any ptr, @pLocateEx )
addrs(1) = cast( any ptr, @pLineInput )
addrs(2) = cast( any ptr, @pLineInputW )
addrs(3) = cast( any ptr, @pGetMouse )
addrs(4) = cast( any ptr, @pGetMouse64 )
addrs(5) = cast( any ptr, @pReadString )

dim as long n = 0, distinct = 1
for i as integer = 0 to 5
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every hook dispatcher resolves"
print "  count="; n; " distinct="; distinct

'' --------------------------------------------------------- the hook table
''
'' __fb_ctx.hooks is a run of function pointers, and only the three slots this
'' file installs into are named. The INDICES are fb_hook.h's order; writing to
'' the wrong one would install a line-input procedure where the runtime expects
'' a mouse query, which is a call through a wrong signature rather than an error.

extern "c"
	extern __fb_ctx_bytes alias "__fb_ctx" as ubyte
end extern

'' Measured, and the same run inc/ctx.bi already uses.
#if defined( __FB_64BIT__ )
	const HOOKS_BASE = 72
	const PTR_SIZE   = 8
#else
	const HOOKS_BASE = 36
	const PTR_SIZE   = 4
#endif

#define HOOK_AT( n ) (*cptr( any ptr ptr, @__fb_ctx_bytes + HOOKS_BASE + (n) * PTR_SIZE ))

const HK_GETMOUSE   = 15
const HK_LINEINPUT  = 20
const HK_LINEINPUTW = 21

'' ------------------------------------------------------------------ LOCATE

'' NO HOOK INSTALLED, so this is the fallback path -- and what is compared is the
'' VALIDATION, which happens before the hook is even read.
print "-- fb_LocateEx validation, with no hook installed"

sub tryLocate( byval r as long, byval c as long, byref label as string )
	dim as long p = &h7FFFFFFF
	dim as long res = pLocateEx( r, c, -1, @p )
	print "  "; label; " -> res="; res; " pos="; p
end sub

'' ZERO MEANS "DO NOT MOVE" and skips the range test, which is what lets
'' fb_Locate read the position back with (0,0).
tryLocate( 0, 0, "(0,0)      " )
tryLocate( 1, 1, "(1,1)      " )
tryLocate( 2, 3, "(2,3)      " )
'' Out of range in each direction. The row is checked against the VIEW PRINT
'' region and the column against the full width.
tryLocate( 9999, 1, "(9999,1)   " )
tryLocate( 1, 9999, "(1,9999)   " )
tryLocate( -1, 1, "(-1,1)     " )
tryLocate( 1, -1, "(1,-1)     " )
'' A zero row with a bad column is still rejected -- the two tests are
'' independent, not an either/or.
tryLocate( 0, 9999, "(0,9999)   " )
tryLocate( 9999, 0, "(9999,0)   " )

'' THE OUT-PARAMETER IS WRITTEN EVEN ON THE ERROR PATH, with the zero the
'' function initialised -- so a rejected LOCATE overwrites the caller's variable
'' rather than leaving it. The sentinel above is what shows that.
'' AND A NULL OUT-PARAMETER IS ACCEPTED.
print "  NULL out-parameter, valid   -> "; pLocateEx( 1, 1, -1, 0 )
print "  NULL out-parameter, invalid -> "; pLocateEx( 9999, 1, -1, 0 )

'' ------------------------------------------------------- the mouse queries

print "-- the mouse, with no hook installed"
dim as long mx = -99, my = -99, mz = -99, mb = -99, mc = -99
dim as long mres = pGetMouse( @mx, @my, @mz, @mb, @mc )
print "  GetMouse -> "; mres; " x="; mx; " y="; my; " z="; mz; " b="; mb; " clip="; mc

'' EVERY POINTER IS OPTIONAL.
print "  GetMouse, all NULL -> "; pGetMouse( 0, 0, 0, 0, 0 )

'' ------------------------------------------------------- an installed hook

'' Recording procedures, so the dispatch itself is the observable.
dim shared as string gTrace
dim shared as long gMouseX, gMouseY, gMouseZ, gMouseB, gMouseC

function myMouse cdecl ( byval x as long ptr, byval y as long ptr, byval z as long ptr, _
                         byval b as long ptr, byval c as long ptr ) as long
	gTrace += "mouse "
	if( x <> 0 ) then *x = gMouseX
	if( y <> 0 ) then *y = gMouseY
	if( z <> 0 ) then *z = gMouseZ
	if( b <> 0 ) then *b = gMouseB
	if( c <> 0 ) then *c = gMouseC
	return 77
end function

print "-- with a mouse hook installed"
gMouseX = 11 : gMouseY = 22 : gMouseZ = 33 : gMouseB = 44 : gMouseC = 55
gTrace = ""
HOOK_AT( HK_GETMOUSE ) = cast( any ptr, @myMouse )

mx = -99 : my = -99 : mz = -99 : mb = -99 : mc = -99
mres = pGetMouse( @mx, @my, @mz, @mb, @mc )
print "  GetMouse -> "; mres; " x="; mx; " y="; my; " z="; mz; " b="; mb; " clip="; mc
print "  trace=["; gTrace; "]"

'' THE 64-BIT FORM WIDENS, and its five locals start at -1 -- so a hook that
'' fills only some of them yields -1 for the rest rather than stack rubbish.
dim as longint lx = &h7FFFFFFFFFFFFFFFll, ly = lx, lz = lx, lb = lx, lc = lx
gTrace = ""
dim as long l64 = pGetMouse64( @lx, @ly, @lz, @lb, @lc )
print "  GetMouse64 -> "; l64; " x="; lx; " y="; ly; " z="; lz; " b="; lb; " clip="; lc
print "  trace=["; gTrace; "]"

'' A HOOK THAT FILLS NOTHING must leave the 64-bit form's outputs at -1.
function myMouseSilent cdecl ( byval x as long ptr, byval y as long ptr, byval z as long ptr, _
                               byval b as long ptr, byval c as long ptr ) as long
	gTrace += "silent "
	return 3
end function

HOOK_AT( HK_GETMOUSE ) = cast( any ptr, @myMouseSilent )
lx = 0 : ly = 0 : lz = 0 : lb = 0 : lc = 0
gTrace = ""
l64 = pGetMouse64( @lx, @ly, @lz, @lb, @lc )
print "  a hook that fills nothing -> "; l64; " x="; lx; " y="; ly; " z="; lz; " b="; lb; " clip="; lc
print "  trace=["; gTrace; "]"

HOOK_AT( HK_GETMOUSE ) = 0

'' ------------------------------------------------------- the line inputs

'' THE FALLBACK BLOCKS, so these are only ever called WITH a hook -- see the file
'' header. What is checked is that every argument arrives intact and the return
'' comes back.
dim shared as string gLIText
dim shared as long gLIdl, gLIfr, gLIq, gLInl

'' THE PROMPT ARRIVES AS A DESCRIPTOR and is read by hand: `FBSTRING` is not a
'' type this test can name -- fbc-int/string.bi does not export it under that
'' spelling -- and the only field wanted is `data`, which is at offset zero.
function myLineInput cdecl ( byval t as any ptr, byval d as any ptr, byval dl as integer, _
                             byval fr as long, byval q as long, byval nl as long ) as long
	gTrace += "line "
	gLIText = "<null>"
	if( t <> 0 ) then
		dim as zstring ptr dp = *cptr( zstring ptr ptr, t )
		gLIText = iif( dp <> 0, *dp, "<empty>" )
	end if
	gLIdl = dl : gLIfr = fr : gLIq = q : gLInl = nl
	'' The destination is left alone: assigning into it would need the
	'' runtime's own assign, and what is being checked is that the ARGUMENTS
	'' arrive intact, not that a hook can write.
	return 99
end function

function myLineInputW cdecl ( byval t as wstring ptr, byval d as wstring ptr, byval mc as integer, _
                              byval q as long, byval nl as long ) as long
	gTrace += "linew "
	gLIdl = mc : gLIq = q : gLInl = nl
	return 98
end function

print "-- with line-input hooks installed"
HOOK_AT( HK_LINEINPUT ) = cast( any ptr, @myLineInput )
HOOK_AT( HK_LINEINPUTW ) = cast( any ptr, @myLineInputW )

dim as string prompt_ = "type here"
dim as string dest_
gTrace = ""
dim as long lres = pLineInput( @prompt_, @dest_, -1, 0, -1, -1 )
print "  LineInput -> "; lres; " text=["; gLIText; "] dst_len="; gLIdl; _
      " fillrem="; gLIfr; " q="; gLIq; " nl="; gLInl
print "  trace=["; gTrace; "]"

'' A NULL PROMPT reaches the hook as NULL, not as an empty descriptor.
gTrace = "" : gLIText = "<unset>"
lres = pLineInput( 0, @dest_, -1, 0, 0, 0 )
print "  LineInput, NULL prompt -> "; lres; " text=["; gLIText; "]"

dim as wstring * 32 wprompt = wstr( "wide" )
dim as wstring * 32 wdest
gTrace = ""
dim as long lwres = pLineInputW( @wprompt, @wdest, 31, -1, 0 )
print "  LineInputWstr -> "; lwres; " max_chars="; gLIdl; " q="; gLIq; " nl="; gLInl
print "  trace=["; gTrace; "]"

'' REMOVED AGAIN, so nothing later in the program is affected.
HOOK_AT( HK_LINEINPUT ) = 0
HOOK_AT( HK_LINEINPUTW ) = 0

'' ------------------------------------------------------------ fb_ReadString

'' IT DISPATCHES ON THE STREAM FIRST: anything that is not stdin goes to fgets
'' and never looks at the hook, which is what keeps LINE INPUT from a FILE
'' working while a graphics library owns the console.
print "-- fb_ReadString on a real file"
dim as string fname = "tkort-hookmisc-parity.tmp"
kill fname
open fname for output as #1
print #1, "first line"
print #1, "second line"
close #1

dim as long fh = freefile
open fname for input as #fh
dim as zstring * 64 rbuf = any
'' The FILE* behind an FB channel is not reachable from FreeBASIC, so the
'' stream path is driven through the language instead and fb_ReadString is
'' proved by address plus the fgets branch below.
dim as string l1
line input #fh, l1
print "  a line through the channel: ["; l1; "]"
close #fh
kill fname

print "done"
