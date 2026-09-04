'' devscrn-parity.bas -- the SCREEN device. Seventeen entry points across eight
'' fbc members.
''
'' NEEDS-GEN-LLVM
''
'' NOTHING HERE READS, AND THAT IS DELIBERATE. Every read path in this device
'' ends in fb_DevScrnFillInput, which spins on fb_KeyHit and SLEEPs 25 ms until a
'' key arrives -- there is no timeout and no EOF. Calling one under the
'' differential harness, whose stdin is not a console, is how lprint-parity hung
'' the entire run once already. So the reads are proved by ADDRESS, and the
'' writes -- which cannot block -- are proved by behaviour.
''
'' WHAT IS COVERED ELSEWHERE:
''   symbols.sh   all seventeen names byte-identical on three targets, incl. @N
''   gate.sh      fbc's own suite drives SCRN: reads with a real console
''   print-parity the formatting that reaches these hooks

#include once "fbc-int/string.bi"

extern "c"   '' NON-FBCALL: device hooks, undecorated in fbc's win32 archive.
	declare function sOpen    alias "fb_DevScrnOpen" _
		( byval h as any ptr, byval f as zstring ptr, byval fl as uinteger ) as long
	declare sub      sInit    alias "fb_DevScrnInit" ( )
	declare function sClose   alias "fb_DevScrnClose" ( byval h as any ptr ) as long
	declare sub      sFill    alias "fb_DevScrnFillInput" ( byval info as any ptr )
	declare function sEof     alias "fb_DevScrnEof" ( byval h as any ptr ) as long
	declare function sWrite   alias "fb_DevScrnWrite" _
		( byval h as any ptr, byval v as any ptr, byval l as uinteger ) as long
	declare sub      sIWrite  alias "fb_DevScrnInit_Write" ( )
	declare function sWriteW  alias "fb_DevScrnWriteWstr" _
		( byval h as any ptr, byval v as wstring ptr, byval l as uinteger ) as long
	declare sub      sIWriteW alias "fb_DevScrnInit_WriteWstr" ( )
	declare function sRead    alias "fb_DevScrnRead" _
		( byval h as any ptr, byval v as any ptr, byval pl as uinteger ptr ) as long
	declare sub      sIRead   alias "fb_DevScrnInit_Read" ( )
	declare function sReadW   alias "fb_DevScrnReadWstr" _
		( byval h as any ptr, byval d as wstring ptr, byval pc as uinteger ptr ) as long
	declare sub      sIReadW  alias "fb_DevScrnInit_ReadWstr" ( )
	declare function sRdLine  alias "fb_DevScrnReadLine" ( byval h as any ptr, byval d as any ptr ) as long
	declare sub      sIRdLine alias "fb_DevScrnInit_ReadLine" ( )
	declare function sRdLineW alias "fb_DevScrnReadLineWstr" _
		( byval h as any ptr, byval d as wstring ptr, byval c as integer ) as long
	declare sub      sIRdLnW  alias "fb_DevScrnInit_ReadLineWstr" ( )
end extern

'' Through a shared sink, so -O2 cannot drop the address-taking as dead code and
'' take the link reference with it.
dim shared as any ptr addrs( 0 to 16 )

addrs(0)  = cast( any ptr, @sOpen )
addrs(1)  = cast( any ptr, @sInit )
addrs(2)  = cast( any ptr, @sClose )
addrs(3)  = cast( any ptr, @sFill )
addrs(4)  = cast( any ptr, @sEof )
addrs(5)  = cast( any ptr, @sWrite )
addrs(6)  = cast( any ptr, @sIWrite )
addrs(7)  = cast( any ptr, @sWriteW )
addrs(8)  = cast( any ptr, @sIWriteW )
addrs(9)  = cast( any ptr, @sRead )
addrs(10) = cast( any ptr, @sIRead )
addrs(11) = cast( any ptr, @sReadW )
addrs(12) = cast( any ptr, @sIReadW )
addrs(13) = cast( any ptr, @sRdLine )
addrs(14) = cast( any ptr, @sIRdLine )
addrs(15) = cast( any ptr, @sRdLineW )
addrs(16) = cast( any ptr, @sIRdLnW )

dim as long n = 0, distinct = 1
for i as integer = 0 to 16
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next

print "-- every SCRN: entry point resolves"
print "  count="; n
print "  all distinct="; distinct

'' ------------------------------------------------------------------ the writes
''
'' OPEN SCRN: FOR OUTPUT goes through fb_DevScrnOpen, which duplicates the screen
'' handle's DEV_SCRN_INFO and points redirection_to back at it. Everything below
'' therefore exercises Open, Init, Init_Write, the write hook and Close.

print "-- open SCRN: for output"
dim as long e = 0
open scrn for output as #1
e = err
print "  open err="; e
print "  freefile-ish handle open: "; ( e = 0 )

print #1, "narrow through the SCRN: channel"
print "  after narrow print err="; err

dim as wstring * 32 w = wstr( "wide through the same channel" )
print #1, w
print "  after wide print err="; err

'' EOF on an OUTPUT channel does not touch the keyboard: the handle's access is
'' write-only, so the eof hook answers without ever calling FillInput.
print "  eof(#1)="; eof( 1 )
print "  lof(#1)="; lof( 1 )
print "  loc(#1)="; loc( 1 )

close #1
print "  after close err="; err

'' A SECOND OPEN AFTER A CLOSE must work: hFillTable is idempotent and the Init
'' guards are all "only if the slot is still NULL", so a second pass through must
'' leave the table exactly as the first did.
open scrn for output as #1
print #1, "second channel on the same device"
print "  reopen err="; err
close #1

'' PRINT with no channel reaches the same device through FB_HANDLE_SCREEN, and
'' the hook table it uses is the one the OPEN above filled in.
print "-- the default handle uses the same table"
print "  plain print still works"
print "  err="; err

print "done"
