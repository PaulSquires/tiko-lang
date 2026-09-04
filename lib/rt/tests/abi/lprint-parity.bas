'' lprint-parity.bas -- the LPRINT family. Fifteen entry points across eleven fbc
'' members.
''
'' NEEDS-GEN-LLVM
''
'' NOTHING HERE CALLS LPRINT, AND THAT IS THE FINDING.
''
'' fb_LPrintInit opens the channel at FB_HANDLE_PRINTER with a FIXED device
'' string -- "LPT:EMU=TTY" on Windows, "LPT:" on Linux -- which is the SYSTEM
'' DEFAULT PRINTER. There is no argument, and `OPEN LPT "x.txt" FOR OUTPUT AS #n`
'' opens a different channel that LPRINT never looks at. So an LPRINT in a test
'' either prints on real paper or talks to the print spooler.
''
'' Two earlier versions of this file learned that the hard way:
''
''   1. The first opened an LPT channel, ran the whole LPRINT vocabulary through
''      it, read the file back and printed `<no file>` twenty-two times. It
''      PASSED, because both runtimes produced the same nothing.
''   2. The second called each entry point once and printed ERR. It passed twice
''      and then HUNG THE ENTIRE DIFFERENTIAL: fbc's own build blocked inside
''      fb_LPrintInit talking to the spooler, and the harness sat on it until it
''      was killed by hand. A test that can hang every other test is worse than
''      no test.
''
'' SO THIS TAKES THE ADDRESS OF EVERY ENTRY POINT AND CALLS NONE OF THEM. That is
'' a real check and the only safe one: it proves all fifteen symbols exist, are
'' declared with the convention the archive uses, and LINK -- which is how the
'' batch's completeness is established. A missing or misdeclared entry point is a
'' link failure, and diff.sh reports a link failure as a FAIL.
''
'' WHAT IS COVERED ELSEWHERE, so that this file's narrowness is not mistaken for
'' the batch's:
''
''   symbols.sh   all fifteen names byte-identical to fbc's on three targets,
''                including the win32 @N decoration
''   gate.sh      fbc's own 2,715-file suite links against these members
''   print-parity the FORMATTING, through the same macro and the same
''                fb_hFloat2Str, on a channel that can be read back

extern "rtlib"
	declare sub      pInt      alias "fb_LPrintInt"       ( byval f as long, byval v as long, byval m as long )
	declare sub      pUInt     alias "fb_LPrintUInt"      ( byval f as long, byval v as ulong, byval m as long )
	declare sub      pShort    alias "fb_LPrintShort"     ( byval f as long, byval v as short, byval m as long )
	declare sub      pUShort   alias "fb_LPrintUShort"    ( byval f as long, byval v as ushort, byval m as long )
	declare sub      pByte     alias "fb_LPrintByte"      ( byval f as long, byval v as byte, byval m as long )
	declare sub      pUByte    alias "fb_LPrintUByte"     ( byval f as long, byval v as ubyte, byval m as long )
	declare sub      pLongint  alias "fb_LPrintLongint"   ( byval f as long, byval v as longint, byval m as long )
	declare sub      pULongint alias "fb_LPrintULongint"  ( byval f as long, byval v as ulongint, byval m as long )
	declare sub      pSingle   alias "fb_LPrintSingle"    ( byval f as long, byval v as single, byval m as long )
	declare sub      pDouble   alias "fb_LPrintDouble"    ( byval f as long, byval v as double, byval m as long )
	declare sub      pBool     alias "fb_LPrintBool"      ( byval f as long, byval v as byte, byval m as long )
	declare sub      pStr      alias "fb_LPrintString"    ( byval f as long, byval s as any ptr, byval m as long )
	declare sub      pFix      alias "fb_LPrintFixString" ( byval f as long, byval s as zstring ptr, byval m as long )
	declare sub      pWstr     alias "fb_LPrintWstr"      ( byval f as long, byval s as wstring ptr, byval m as long )
	declare sub      pVoid     alias "fb_LPrintVoid"      ( byval f as long, byval m as long )
	declare function pUsing    alias "fb_LPrintUsingInit" ( byval s as any ptr ) as long
end extern

'' Through a volatile-ish sink so the optimiser cannot fold the whole thing away:
'' every address goes into a shared array that is then summed. Taking an address
'' and discarding it would be dead code at -O2 and the link reference could in
'' principle go with it.
dim shared as any ptr addrs( 0 to 15 )

addrs(0)  = cast( any ptr, @pInt )
addrs(1)  = cast( any ptr, @pUInt )
addrs(2)  = cast( any ptr, @pShort )
addrs(3)  = cast( any ptr, @pUShort )
addrs(4)  = cast( any ptr, @pByte )
addrs(5)  = cast( any ptr, @pUByte )
addrs(6)  = cast( any ptr, @pLongint )
addrs(7)  = cast( any ptr, @pULongint )
addrs(8)  = cast( any ptr, @pSingle )
addrs(9)  = cast( any ptr, @pDouble )
addrs(10) = cast( any ptr, @pBool )
addrs(11) = cast( any ptr, @pStr )
addrs(12) = cast( any ptr, @pFix )
addrs(13) = cast( any ptr, @pWstr )
addrs(14) = cast( any ptr, @pVoid )
addrs(15) = cast( any ptr, @pUsing )

dim as long n = 0, distinct = 1
for i as integer = 0 to 15
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next

print "-- every LPRINT entry point resolves"
print "  count="; n
print "  all distinct="; distinct

print "done"
