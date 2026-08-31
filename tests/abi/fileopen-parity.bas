'' fileopen-parity.bas -- OPEN in all nine spellings. Fourteen entry points
'' across eleven fbc members.
''
'' NEEDS-GEN-LLVM
''
'' fb_LPrintInit IS TAKEN BY ADDRESS AND NEVER CALLED. It opens the SYSTEM
'' DEFAULT PRINTER with a fixed device string, and calling it once hung the whole
'' differential inside the Windows print spooler -- see lprint-parity.bas for the
'' full account. Everything else here is driven.
''
'' OPEN COM: AND OPEN LPT: ARE ALSO ADDRESS-ONLY, for the same reason and one
'' more: a machine with a real serial port would behave differently from one
'' without, so the test would be measuring the hardware rather than the runtime.
'' What IS driven is their SHARED path -- fb_FileOpenVfsEx's validation, clearing
'' and reclen rules -- through OPEN, OPEN SCRN:, OPEN CONS: and OPEN ENCODING,
'' which reach exactly the same code with a different pfnOpen.

#include once "fbc-int/string.bi"

extern "c"
	declare function pVfsRawEx alias "fb_FileOpenVfsRawEx" _
		( byval h as any ptr, byval f as zstring ptr, byval l as uinteger, _
		  byval m as ulong, byval a as ulong, byval k as ulong, byval r as long, _
		  byval e as long, byval p as any ptr ) as long
	declare function pVfsEx alias "fb_FileOpenVfsEx" _
		( byval h as any ptr, byval s as any ptr, byval m as ulong, byval a as ulong, _
		  byval k as ulong, byval r as long, byval e as long, byval p as any ptr ) as long
	declare function pOpenEx alias "fb_FileOpenEx" _
		( byval h as any ptr, byval s as any ptr, byval m as ulong, byval a as ulong, _
		  byval k as ulong, byval r as long ) as long
	declare function pStrToEnc alias "fb_hFileStrToEncoding" ( byval e as zstring ptr ) as long
	declare function pLPrintInit alias "fb_LPrintInit" ( ) as long
end extern

extern "rtlib"
	declare function pOpen      alias "fb_FileOpen" _
		( byval s as any ptr, byval m as ulong, byval a as ulong, byval k as ulong, _
		  byval n as long, byval r as long ) as long
	declare function pOpenScrn  alias "fb_FileOpenScrn" _
		( byval s as any ptr, byval m as ulong, byval a as ulong, byval k as ulong, _
		  byval n as long, byval r as long, byval e as zstring ptr ) as long
	declare function pOpenCons  alias "fb_FileOpenCons" _
		( byval s as any ptr, byval m as ulong, byval a as ulong, byval k as ulong, _
		  byval n as long, byval r as long, byval e as zstring ptr ) as long
	declare function pOpenErr   alias "fb_FileOpenErr" _
		( byval s as any ptr, byval m as ulong, byval a as ulong, byval k as ulong, _
		  byval n as long, byval r as long, byval e as zstring ptr ) as long
	declare function pOpenPipe  alias "fb_FileOpenPipe" _
		( byval s as any ptr, byval m as ulong, byval a as ulong, byval k as ulong, _
		  byval n as long, byval r as long, byval e as zstring ptr ) as long
	declare function pOpenCom   alias "fb_FileOpenCom" _
		( byval s as any ptr, byval m as ulong, byval a as ulong, byval k as ulong, _
		  byval n as long, byval r as long, byval e as zstring ptr ) as long
	declare function pOpenLpt   alias "fb_FileOpenLpt" _
		( byval s as any ptr, byval m as ulong, byval a as ulong, byval k as ulong, _
		  byval n as long, byval r as long, byval e as zstring ptr ) as long
	declare function pOpenEncod alias "fb_FileOpenEncod" _
		( byval s as any ptr, byval m as ulong, byval a as ulong, byval k as ulong, _
		  byval n as long, byval r as long, byval e as zstring ptr ) as long
	declare function pOpenShort alias "fb_FileOpenShort" _
		( byval fm as any ptr, byval n as long, byval fn_ as any ptr, byval r as long, _
		  byval am as any ptr, byval lm as any ptr ) as long
end extern

dim shared as any ptr addrs( 0 to 13 )
addrs(0)  = cast( any ptr, @pVfsRawEx )
addrs(1)  = cast( any ptr, @pVfsEx )
addrs(2)  = cast( any ptr, @pOpenEx )
addrs(3)  = cast( any ptr, @pStrToEnc )
addrs(4)  = cast( any ptr, @pLPrintInit )
addrs(5)  = cast( any ptr, @pOpen )
addrs(6)  = cast( any ptr, @pOpenScrn )
addrs(7)  = cast( any ptr, @pOpenCons )
addrs(8)  = cast( any ptr, @pOpenErr )
addrs(9)  = cast( any ptr, @pOpenPipe )
addrs(10) = cast( any ptr, @pOpenCom )
addrs(11) = cast( any ptr, @pOpenLpt )
addrs(12) = cast( any ptr, @pOpenEncod )
addrs(13) = cast( any ptr, @pOpenShort )

dim as long n = 0, distinct = 1
for i as integer = 0 to 13
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every OPEN entry point resolves"
print "  count="; n; " distinct="; distinct

'' ------------------------------------------------------------------ encoding

'' fb_hFileStrToEncoding, exhaustively -- including the four shapes that are
'' silently the DEFAULT rather than an error, which is where a reimplementation
'' goes wrong without anything saying so.
print "-- fb_hFileStrToEncoding"
dim as zstring ptr cases_(0 to 15) = { _
	@"utf8", @"UTF8", @"utf-8", @"UTF-8", @"utf16", @"UTF-16", @"utf32", @"UTF-32", _
	@"ascii", @"ASC", @"AsCiI", @"", @"utf", @"UTF-16 ", @"16", @"utf-64" }
for i as integer = 0 to 15
	print "  ["; *cases_(i); "] -> "; pStrToEnc( cases_(i) )
next
print "  [NULL] -> "; pStrToEnc( 0 )

'' ------------------------------------------------------------------ validation

'' THE FILE NUMBER IS CHECKED BEFORE THE TABLE IS INDEXED, in all nine. An
'' out-of-range number must be error 1 rather than an entry past the end of
'' __fb_ctx.fileTB -- which would be a silent write into the field that follows.
print "-- file-number validation"
const BAD1 = 0
const BAD2 = -1
const BAD3 = 256
const BAD4 = 999
dim as string nm = "tkort-fileopen-parity.tmp"
for each_ as integer = 0 to 3
	dim as long fnum = 0
	select case each_
	case 0 : fnum = BAD1
	case 1 : fnum = BAD2
	case 2 : fnum = BAD3
	case 3 : fnum = BAD4
	end select
	print "  fnum="; fnum; _
	      " open="; pOpen( @nm, 0, 0, 3, fnum, 0 ); _
	      " scrn="; pOpenScrn( @nm, 0, 0, 3, fnum, 0, 0 ); _
	      " cons="; pOpenCons( @nm, 0, 0, 3, fnum, 0, 0 ); _
	      " encod="; pOpenEncod( @nm, 0, 0, 3, fnum, 0, @"utf8" )
next

'' ------------------------------------------------------------------ reclen

'' 128 IS THE DEFAULT FOR RANDOM, INPUT AND OUTPUT AND ZERO FOR BINARY AND
'' APPEND, and LOC is what makes the difference visible: in the sequential modes
'' it reports 128-byte blocks, in BINARY it reports what TELL gave. A handle that
'' got the wrong reclen therefore reports a plausible LOC rather than an error.
print "-- reclen defaults, seen through LOC"
kill nm
open nm for output as #1
print #1, string( 300, "x" )
close #1

open nm for input as #1
dim as string s300
line input #1, s300
print "  input  len="; len( s300 ); " loc="; loc( 1 ); " lof="; lof( 1 )
close #1

open nm for binary as #1
dim as string b300 = space( 300 )
get #1, , b300
print "  binary loc="; loc( 1 ); " lof="; lof( 1 )
close #1

'' ------------------------------------------------------------------ reopen

'' AN ALREADY-OPEN NUMBER IS ERROR 1 and, crucially, THE SECOND OPEN MUST NOT
'' DISTURB THE FIRST -- the early return happens before the memset.
print "-- open on a number already open"
open nm for input as #1
print "  second open on #1 returns="; pOpen( @nm, 2, 1, 0, 1, 0 )
line input #1, s300
print "  first handle still readable, len="; len( s300 )
close #1

'' AND A FAILED OPEN LEAVES THE NUMBER FREE. This is the memset-on-failure path:
'' without it the slot would keep its hooks and be unusable for the rest of the
'' program.
print "-- a failed open leaves the number reusable"
print "  failed open returns="; open( "tkort-no-such-file-anywhere.tmp" for input as #1 )
print "  reuse of #1 returns="; open( nm for input as #1 )
close #1

'' ------------------------------------------------------------------ short form

'' THE THREE MODE STRINGS, INCLUDING THE ONES THAT MUST FAIL. A two-character
'' file mode, a three-character access mode and an unknown letter are each error
'' 1 -- and the three temp descriptors are still deleted, which allocation
'' counting elsewhere is what actually proves.
print "-- OPEN, the short QB form"
kill nm
dim as string fm, am, lm
dim as zstring ptr modes(0 to 8) = { @"O", @"o", @"I", @"B", @"A", @"R", @"X", @"OO", @"" }
for i as integer = 0 to 8
	fm = *modes(i)
	am = ""
	lm = ""
	dim as long r = pOpenShort( @fm, 1, @nm, 0, @am, @lm )
	print "  mode ["; fm; "] -> "; r
	if( r = 0 ) then close #1
	kill nm
next

print "-- short form, access and lock strings"
dim as zstring ptr accs(0 to 4) = { @"R", @"W", @"RW", @"rw", @"XY" }
for i as integer = 0 to 4
	fm = "B"
	am = *accs(i)
	lm = ""
	dim as long r = pOpenShort( @fm, 1, @nm, 0, @am, @lm )
	print "  access ["; am; "] -> "; r
	if( r = 0 ) then close #1
	kill nm
next

dim as zstring ptr lks(0 to 5) = { @"S", @"R", @"W", @"RW", @"rw", @"Z" }
for i as integer = 0 to 5
	fm = "B"
	am = ""
	lm = *lks(i)
	dim as long r = pOpenShort( @fm, 1, @nm, 0, @am, @lm )
	print "  lock ["; lm; "] -> "; r
	if( r = 0 ) then close #1
	kill nm
next

'' ------------------------------------------------------------------ encoding open

'' ASCII MUST GO TO THE PLAIN DEVICE. An ENCODING "ascii" file has no BOM, so a
'' handle routed to the encoding device instead would skip bytes that are data.
print "-- OPEN ... ENCODING"
kill nm
open nm for output encoding "ascii" as #1
print #1, "ascii-encoded line"
close #1
open nm for binary as #1
print "  ascii file size (no BOM if 20)="; lof( 1 )
close #1

kill nm
open nm for output encoding "utf8" as #1
print #1, "utf8 line"
close #1
open nm for binary as #1
print "  utf8 file size (BOM adds 3)="; lof( 1 )
close #1

kill nm
print "done"
