'' sysmisc-parity.bas -- the small singletons and the QB OPEN dispatcher. Eight
'' entry points across seven fbc members.
''
'' NEEDS-GEN-LLVM
''
'' MOST OF THIS FILE IS ABOUT WHAT **CANNOT** BE CALLED, and saying so is the
'' point rather than an apology:
''
''   fb_Beep          MAKES A NOISE and, on POSIX, writes an escape sequence to
''                    the terminal -- which under the differential harness is a
''                    PIPE, so the bytes would land in the compared output and
''                    the two runtimes would agree on them for the wrong reason.
''                    Proved by ADDRESS only.
''   fb_SleepQB       forwards to fb_Sleep, and fb_Sleep with a NEGATIVE argument
''                    waits for a KEYPRESS -- which never comes under a harness
''                    with no console, so the differential would hang rather than
''                    fail. Only the non-negative path is driven, and only with a
''                    small value.
''   fb_InkeyQB       forwards to fb_Inkey, which READS THE CONSOLE. With stdin a
''                    pipe it returns immediately with an empty string, so the
''                    call is safe -- but it is then testing almost nothing, and
''                    the extended-key rewrite it exists for is unreachable here.
''                    Called anyway, and the limit is stated.
''   fb_hConsoleGetHandle / fb_hConsoleResetHandles
''                    MUTATE __fb_con's cached handles. Calling them under the
''                    harness would repoint the console layer at the pipe's
''                    handles mid-run, which is not itself wrong, but the reset
''                    also clears a flag the print path depends on. Address only.
''
'' SO WHAT IS ACTUALLY DRIVEN IS fb_hGetShortPath, fb_hShell, fb_FileCopy and
'' fb_FileOpenQB -- all four of which have observable, comparable effects on the
'' file system.
''
'' fb_hShell IS RUN WITH A HARMLESS COMMAND ONLY. It is `system()`, so it goes
'' through the platform shell and blocks; the commands here are a successful
'' no-op and a guaranteed failure, chosen so the EXIT CODE is what is compared
'' and nothing is written anywhere.
''
'' AND fb_FileOpenQB IS DRIVEN THROUGH ITS DISPATCH CHAIN, NOT ITS DEVICES. Every
'' case below either opens an ordinary file or is REJECTED before a device driver
'' is reached -- opening a real COM port or the printer would block on hardware
'' this machine may not have. What is compared is the ERROR CODE and which branch
'' the name took, which is exactly what this entry point decides.

#include once "fbc-int/string.bi"

#ifdef __FB_WIN32__
	const SEPQB = "\"
#else
	const SEPQB = "/"
#endif

extern "rtlib"
	declare function pOpenQB   alias "fb_FileOpenQB" _
		( byval s as any ptr, byval m as ulong, byval a as ulong, byval l as ulong, _
		  byval fnum as long, byval ln as long ) as long
	declare function pFileCopy alias "fb_FileCopy" ( byval s as zstring ptr, byval d as zstring ptr ) as long
	declare sub      pBeep     alias "fb_Beep" ( )
	declare sub      pSleepQB  alias "fb_SleepQB" ( byval secs as long )
	declare function pInkeyQB  alias "fb_InkeyQB" ( ) as any ptr
	declare function pClose    alias "fb_FileClose" ( byval fnum as long ) as long
	declare function pDelTemp  alias "fb_hStrDelTemp" ( byval s as any ptr ) as long
	declare function pTimer    alias "fb_Timer" ( ) as double
end extern

extern "c"
	declare function pShell     alias "fb_hShell" ( byval p as zstring ptr ) as long
	declare function c_fopen    alias "fopen"  ( byval p as zstring ptr, byval m as zstring ptr ) as any ptr
	declare function c_fclose   alias "fclose" ( byval f as any ptr ) as long
	declare function c_fwrite   alias "fwrite" ( byval b as any ptr, byval sz as uinteger, byval n as uinteger, byval f as any ptr ) as uinteger
	declare function c_fread    alias "fread"  ( byval b as any ptr, byval sz as uinteger, byval n as uinteger, byval f as any ptr ) as uinteger
	declare function c_fseek    alias "fseek"  ( byval f as any ptr, byval o as long, byval w as long ) as long
	declare function c_ftell    alias "ftell"  ( byval f as any ptr ) as long
	declare function c_remove   alias "remove" ( byval p as zstring ptr ) as long
end extern

#ifdef __FB_WIN32__
	extern "c"
		declare function pShortPath alias "fb_hGetShortPath" _
			( byval s as zstring ptr, byval d as zstring ptr, byval m as integer ) as zstring ptr
		declare function pConGetHnd alias "fb_hConsoleGetHandle" ( byval isin as long ) as any ptr
		declare sub      pConReset  alias "fb_hConsoleResetHandles" ( )
	end extern
#endif

print "-- resolution"
print "  FileOpenQB, FileCopy, Beep, SleepQB, InkeyQB all distinct=";
dim shared as any ptr a5( 0 to 4 )
a5(0) = cast( any ptr, @pOpenQB )  : a5(1) = cast( any ptr, @pFileCopy )
a5(2) = cast( any ptr, @pBeep )    : a5(3) = cast( any ptr, @pSleepQB )
a5(4) = cast( any ptr, @pInkeyQB )
dim as long d5 = 1
for i as integer = 0 to 4
	if( a5(i) = 0 ) then d5 = 0
	for j as integer = 0 to i - 1
		if( a5(i) = a5(j) ) then d5 = 0
	next
next
print d5
print "  fb_hShell resolves="; ( cast( any ptr, @pShell ) <> 0 )
#ifdef __FB_WIN32__
	print "  fb_hGetShortPath resolves="; ( cast( any ptr, @pShortPath ) <> 0 )
	print "  the two console-handle entry points resolve and differ="; _
	      ( (cast( any ptr, @pConGetHnd ) <> 0) andalso _
	        (cast( any ptr, @pConGetHnd ) <> cast( any ptr, @pConReset )) )
#else
	print "  fb_hGetShortPath: WINDOWS ONLY, not present on this target"
	print "  io_gethnd: WINDOWS ONLY, not present on this target"
#endif
print "  fb_Beep: proved by ADDRESS ONLY -- see the file header"

'' -------------------------------------------------------- fb_hGetShortPath

#ifdef __FB_WIN32__

'' THE SPACE TEST IS THE WHOLE FUNCTION: with no space it is a bounded copy and
'' Windows is never consulted, so a path that does not exist still comes back
'' unchanged. The buffer is pre-filled so the bounded copy's terminator handling
'' is visible.
print "-- fb_hGetShortPath"
sub tryShort( byref s as string, byval cap as integer )
	dim as zstring * 512 b = any
	for i as integer = 0 to 511
		b[i] = 42                        '' asterisk sentinel
	next
	b[511] = 0
	dim as zstring ptr r = pShortPath( strptr( s ), @b, cap )
	print "  ["; s; "] cap="; cap; " -> returns dst="; ( r = @b ); " ["; b; "]"
end sub

'' NO SPACE: copied verbatim, existence irrelevant.
tryShort( "C:\nosuchpath\file.txt", 512 )
tryShort( "relative\path", 512 )
tryShort( "plain", 512 )
'' THE EMPTY STRING IS **NOT** PASSED. strptr( "" ) is NULL in FreeBASIC, and
'' fb_hGetShortPath opens with `strchr( src, 32 )` -- so a NULL source is
'' dereferenced and both runtimes segfault identically, which the harness
'' reports as "both sides exited non-zero" and which proves nothing. An empty
'' zstring buffer is passed instead, below, which is a real empty string with a
'' real address.
dim shared as zstring * 4 emptysrc = any
emptysrc[0] = 0
scope
	dim as zstring * 512 b = any
	for i as integer = 0 to 511
		b[i] = 42
	next
	b[511] = 0
	dim as zstring ptr r = pShortPath( @emptysrc, @b, 512 )
	print "  [<empty>] cap= 512 -> returns dst="; ( r = @b ); " ["; b; "]"
end scope
'' A SHORT BUFFER, where strncpy does not terminate and the byte is written back
'' by hand -- the case that would silently overrun if that line were dropped.
tryShort( "C:\nosuchpath\file.txt", 8 )
tryShort( "C:\nosuchpath\file.txt", 1 )
'' WITH A SPACE: Windows IS consulted, and for a non-existent path it fails and
'' leaves the buffer untouched -- which is why the sentinel is still visible.
'' That is fbc's unchecked call, reproduced.
tryShort( "C:\no such path\file.txt", 512 )
'' A PATH WITH A SPACE THAT DOES EXIST, so the call succeeds. The RESULT is
'' machine-dependent (8.3 generation may be off), so only its shape is checked.
dim shared as zstring * 512 realbuf = any
dim as zstring ptr rp = pShortPath( @"C:\Program Files", @realbuf, 512 )
print "  [C:\Program Files] -> non-empty="; ( len( realbuf ) > 0 ); " returns dst="; ( rp = @realbuf )

#endif

'' -------------------------------------------------------------- fb_hShell

'' A SUCCESSFUL NO-OP AND A GUARANTEED FAILURE. What is compared is the exit
'' code, and nothing is written anywhere -- see the file header.
print "-- fb_hShell"
#ifdef __FB_WIN32__
	print "  [cd .] -> "; pShell( @"cd ." )
	print "  [nonexistentcommand12345] -> non-zero="; ( pShell( @"nonexistentcommand12345 2>nul" ) <> 0 )
#else
	print "  [true] -> "; pShell( @"true" )
	print "  [false] -> non-zero="; ( pShell( @"false" ) <> 0 )
#endif

'' -------------------------------------------------------------- fb_FileCopy

'' THE ONE HERE WITH A FULLY OBSERVABLE EFFECT. A scratch file is written,
'' copied, and the copy's CONTENT is read back -- because the return code alone
'' would not distinguish a real copy from a zero-byte file created successfully.
print "-- fb_FileCopy"
const SRC = "tkrt-copysrc.tmp"
const DST = "tkrt-copydst.tmp"

c_remove( @SRC ) : c_remove( @DST )

dim as any ptr cf = c_fopen( @SRC, @"wb" )
dim as zstring * 32 payload = "COPY-ME-0123456789"
c_fwrite( @payload, 1, 18, cf )
c_fclose( cf )

print "  copy -> "; pFileCopy( @SRC, @DST )

dim as any ptr rf = c_fopen( @DST, @"rb" )
print "  destination opened="; ( rf <> 0 )
if( rf <> 0 ) then
	dim as zstring * 64 back = any
	for i as integer = 0 to 63
		back[i] = 0
	next
	dim as uinteger n = c_fread( @back, 1, 32, rf )
	c_fclose( rf )
	print "  read back n="; n; " ["; back; "]"
	print "  content matches="; ( back = "COPY-ME-0123456789" )
end if

'' OVERWRITING AN EXISTING DESTINATION SUCCEEDS on both platforms -- the one
'' respect in which CopyFile and the POSIX loop agree.
print "  copy again over the existing destination -> "; pFileCopy( @SRC, @DST )

'' A MISSING SOURCE FAILS, and the error code is what is compared.
print "  missing source -> "; pFileCopy( @"tkrt-nosuchsource.tmp", @DST )

'' AN UNWRITABLE DESTINATION. A path through a directory that does not exist
'' fails on both platforms without creating anything.
print "  bad destination -> "; pFileCopy( @SRC, @"tkrt-nosuchdir\x.tmp" )

c_remove( @SRC ) : c_remove( @DST )

'' ------------------------------------------------------------ fb_FileOpenQB

'' DRIVEN THROUGH THE DISPATCH CHAIN, NOT INTO THE DEVICES -- see the file
'' header. Every case is either an ordinary file or a rejection.
print "-- fb_FileOpenQB"

const QBFILE = "tkrt-openqb.tmp"
c_remove( @QBFILE )

'' fb_file.h's mode/access constants, spelled as the numbers fbc's codegen
'' passes: mode INPUT=0 OUTPUT=1 RANDOM=2 APPEND=3 BINARY=4.
const MODE_OUTPUT = 1
const MODE_INPUT  = 0

sub tryOpen( byref label as string, byref name_ as string, byval mode_ as ulong, byval fnum as long )
	dim as string s = name_
	dim as long r = pOpenQB( @s, mode_, 0, 0, fnum, 0 )
	print "  "; label; " ["; name_; "] fnum="; fnum; " -> err="; r
	if( r = 0 ) then pClose( fnum )
end sub

'' AN ORDINARY FILE, which is the fall-through case and the only one that
'' actually opens anything here.
tryOpen( "plain file    ", QBFILE, MODE_OUTPUT, 1 )
tryOpen( "reopen        ", QBFILE, MODE_INPUT, 1 )
c_remove( @QBFILE )

'' THE CHANNEL CHECK COMES FIRST, so an invalid fnum reports the channel error
'' even with a filename that would have been rejected anyway.
print "-- the channel check precedes the filename check"
tryOpen( "fnum 0        ", QBFILE, MODE_OUTPUT, 0 )
tryOpen( "fnum -1       ", QBFILE, MODE_OUTPUT, -1 )
tryOpen( "fnum 9999     ", QBFILE, MODE_OUTPUT, 9999 )
'' AND THE SAME INVALID CHANNEL WITH AN EMPTY NAME gives the channel error, not
'' the empty-name one -- which is what proves the order.
dim shared as string emptyname
emptyname = ""   '' assigned, not initialised -- error 87 otherwise
print "  fnum 0 + empty name -> err="; pOpenQB( @emptyname, MODE_OUTPUT, 0, 0, 0, 0 )
print "  fnum 1 + empty name -> err="; pOpenQB( @emptyname, MODE_OUTPUT, 0, 0, 1, 0 )
'' A NULL DESCRIPTOR IS **NOT** PASSED. fb_FileOpenQB reads FB_STRSIZE( str )
'' BEFORE it tests `str->data`, so a NULL argument is dereferenced and both
'' runtimes segfault identically -- which the harness reports as "both sides
'' exited non-zero" and which proves nothing about the arithmetic. The
'' precedence that IS observable is the channel check running before the
'' filename check, which the two cases above establish.

'' THE NAMES THAT LOOK LIKE DEVICES BUT ARE NOT, as far as fb_FileOpenQB is
'' concerned -- each falls through the whole chain to the ordinary-file case, and
'' the exact lengths are the reason.
''
'' NONE OF THEM IS ALLOWED TO CREATE A FILE, and that took three tries to get
'' right:
''
''   1. Opening them for OUTPUT under their own names left `PRN`, `CONS` and
''      `SCRN` in the repository root. `PRN` is a WINDOWS RESERVED DEVICE NAME --
''      it resolves to the printer at the Win32 layer whatever the runtime above
''      decided -- and git could not even open it to index it. Clearing it needed
''      an extended-length delete.
''   2. Prefixing the names moved the problem: `tkrt-qb-PRN:x` is not a filename
''      on NTFS, it is the ALTERNATE DATA STREAM `x` of the file `tkrt-qb-PRN` --
''      so the open created the base file and `remove` deleted only the stream,
''      leaving the base behind.
''
'' SO EVERY NAME IS PUT UNDER A DIRECTORY THAT DOES NOT EXIST. The open then
'' fails at the file system, which is exactly what proves it reached the
'' ordinary-file branch -- a name the dispatcher had claimed for a device would
'' have returned a device error or succeeded instead. Nothing is created and
'' nothing needs removing.
print "-- device-shaped names that take the ordinary-file path"

const NODIR = "tkrt-nosuchdir-qb"

sub tryOpenNoCreate( byref label as string, byref bare as string )
	dim as string name_ = NODIR + SEPQB + bare
	dim as string s = name_
	dim as long r = pOpenQB( @s, MODE_OUTPUT, 0, 0, 2, 0 )
	print "  "; label; " ["; bare; "] -> err="; r
	'' Should never open, but close and remove if it somehow did, so a surprise
	'' cannot leak into the working tree.
	if( r = 0 ) then
		pClose( 2 )
		c_remove( strptr( name_ ) )
	end if
end sub

'' "PRN:" IS EXACTLY FOUR CHARACTERS, so five is a file.
tryOpenNoCreate( "PRN:x     ", "PRN:x" )
'' "CONS:" IS EXACTLY FIVE, so four and six are files.
tryOpenNoCreate( "CONS      ", "CONS" )
tryOpenNoCreate( "CONS:x    ", "CONS:x" )
tryOpenNoCreate( "SCRN:x    ", "SCRN:x" )
'' A COM OR LPT NAME WITH NO COLON falls all the way through -- and note it is
'' NOT retried against the other branch, because the chain is `else if`.
tryOpenNoCreate( "COM1      ", "COM1" )
tryOpenNoCreate( "LPT1      ", "LPT1" )
tryOpenNoCreate( "COMx-     ", "COMx-" )
'' THREE CHARACTERS EXACTLY fails the `> 3` test on both numbered branches.
tryOpenNoCreate( "COM       ", "COM" )
tryOpenNoCreate( "LPT       ", "LPT" )

'' ---------------------------------------------------- fb_SleepQB, fb_InkeyQB

'' SECONDS, NOT MILLISECONDS. Verified against fb_Timer as a BAND -- see
'' hostinfo-parity for why an equality would be wrong. NEGATIVE IS NOT CALLED:
'' fb_Sleep reads it as "wait for a keypress", which under this harness never
'' arrives.
print "-- fb_SleepQB (non-negative only; the negative path would HANG)"
dim as double t0 = pTimer( )
pSleepQB( 0 )
print "  SleepQB(0) under 1s="; ( (pTimer( ) - t0) < 1.0 )

'' fb_InkeyQB with stdin a pipe returns an empty string immediately. The
'' extended-key rewrite it exists for is unreachable here and is NOT covered.
print "-- fb_InkeyQB (empty-input path only; the extended-key rewrite is NOT covered)"
dim as any ptr ik = pInkeyQB( )
if( ik = 0 ) then
	print "  <NULL ptr>"
elseif( *cptr( zstring ptr ptr, ik ) = 0 ) then
	print "  <nulldesc>"
else
	print "  len="; len( *(*cptr( zstring ptr ptr, ik )) )
	pDelTemp( ik )
end if

print "done"
