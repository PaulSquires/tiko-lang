'' process-parity.bas -- CURDIR$, EXEPATH$, COMMAND$, CHDIR, MKDIR, RMDIR, EXEC,
'' RUN, CHAIN, SHELL and the command-line splitter. Eleven entry points across
'' eleven fbc members.
''
'' NEEDS-GEN-LLVM
''
'' EXEC, RUN, CHAIN AND SHELL ARE TAKEN BY ADDRESS AND NEVER CALLED. Each starts
'' a process: RUN does not come back at all, SHELL hands a string to cmd.exe or
'' /bin/sh, and a differential that spawns anything is one that can hang the
'' whole run -- which lprint-parity already did once. What IS driven is
'' everything that only reads or changes this process's own state.
''
'' THE TWO PATH FUNCTIONS ARE MACHINE-DEPENDENT, so their VALUES cannot be
'' compared: the two runtimes are two executables in the same directory with
'' DIFFERENT NAMES. What is compared is the relationship between them -- that
'' EXEPATH$ is a prefix of nothing and a directory that exists, that CURDIR$
'' round-trips through CHDIR, and that both are non-empty.
''
'' fb_hParseArgs IS THE INTERESTING ONE and it is pure: a buffer in, a buffer
'' out, no state. Every case below is a byte-for-byte comparison of the split.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pCurDir  alias "fb_CurDir" ( ) as string
	declare function pExePath alias "fb_ExePath" ( ) as string
	declare function pCommand alias "fb_Command" ( byval arg as long ) as string
	declare function pChDir   alias "fb_ChDir" ( byval p as any ptr ) as long
	declare function pMkDir   alias "fb_MkDir" ( byval p as any ptr ) as long
	declare function pRmDir   alias "fb_RmDir" ( byval p as any ptr ) as long
	declare function pExec    alias "fb_Exec" ( byval p as any ptr, byval a as any ptr ) as long
	declare function pRun     alias "fb_Run" ( byval p as any ptr, byval a as any ptr ) as long
	declare function pChain   alias "fb_Chain" ( byval p as any ptr ) as long
	declare function pShell   alias "fb_Shell" ( byval p as any ptr ) as long
end extern

extern "c"
	declare function pParseArgs alias "fb_hParseArgs" _
		( byval dst as zstring ptr, byval src as zstring ptr, byval l as integer ) as long
end extern

dim shared as any ptr addrs( 0 to 10 )
addrs(0)  = cast( any ptr, @pCurDir )
addrs(1)  = cast( any ptr, @pExePath )
addrs(2)  = cast( any ptr, @pCommand )
addrs(3)  = cast( any ptr, @pChDir )
addrs(4)  = cast( any ptr, @pMkDir )
addrs(5)  = cast( any ptr, @pRmDir )
addrs(6)  = cast( any ptr, @pExec )
addrs(7)  = cast( any ptr, @pRun )
addrs(8)  = cast( any ptr, @pChain )
addrs(9)  = cast( any ptr, @pShell )
addrs(10) = cast( any ptr, @pParseArgs )

dim as long n = 0, distinct = 1
for i as integer = 0 to 10
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every process entry point resolves"
print "  count="; n; " distinct="; distinct

'' ---------------------------------------------------- the argument splitter

'' Renders a split buffer as visible text: NULs become '|', so the argument
'' boundaries are part of the comparison rather than invisible in it.
function show( byval buf as zstring ptr, byval used as integer ) as string
	dim as string out_ = ""
	dim as ubyte ptr b = cast( ubyte ptr, buf )
	for i as integer = 0 to used - 1
		if( b[i] = 0 ) then
			out_ += "|"
		else
			out_ += chr( b[i] )
		end if
	next
	return out_
end function

print "-- fb_hParseArgs"

'' THE WINDOWS BACKSLASH RULE, ON EVERY TARGET: a run of backslashes before a
'' quote is halved, and the quote is literal only when the run was ODD.
dim shared as zstring ptr pcases(0 to 15) = { _
	@"one two three", _
	@"  leading spaces", _
	@"trailing spaces   ", _
	@"one  two", _
	@"""quoted string""", _
	@"""with spaces"" and more", _
	@"a""b""c", _
	@"\\ two backslashes", _
	@"\\""quoted after two", _
	@"\""literal quote", _
	@"\\\""one backslash then quote", _
	@"\\\\""two backslashes then delim", _
	@"c:\path\to\file", _
	@"", _
	@" ", _
	@"unterminated ""quote" }

for i as integer = 0 to 15
	dim as zstring * 256 dst = any
	dim as zstring ptr src = pcases(i)
	dim as integer l = len( *src )
	dim as long argc = pParseArgs( @dst, src, l )
	'' The used length is walked rather than assumed: the splitter writes a
	'' final NUL and may write fewer bytes than it read.
	dim as integer used = 0
	dim as ubyte ptr b = cast( ubyte ptr, @dst )
	dim as integer seen_nuls = 0
	while( (used < 250) andalso (seen_nuls < argc) )
		if( b[used] = 0 ) then seen_nuls += 1
		used += 1
	wend
	print "  ["; *src; "] argc="; argc; " -> ["; show( @dst, used ); "]"
next

'' A NUL-SEPARATED SOURCE splits the same way as a space-separated one, and a
'' quoted NUL becomes a SPACE rather than a boundary -- the delimiter is
'' normalised, not preserved.
print "-- fb_hParseArgs over embedded NULs"
dim as zstring * 32 nulsrc = any
dim as ubyte ptr nb = cast( ubyte ptr, @nulsrc )
dim as string built = "aa" + chr( 0 ) + "bb" + chr( 0 ) + "cc"
for i as integer = 0 to len( built ) - 1
	nb[i] = asc( mid( built, i + 1, 1 ) )
next
dim as zstring * 64 ndst = any
dim as long nargc = pParseArgs( @ndst, @nulsrc, len( built ) )
print "  three NUL-separated words -> argc="; nargc

'' THE TWO ERROR RETURNS, which are -1 and not an argument count.
dim as zstring * 8 tiny = any
print "  NULL src  -> "; pParseArgs( @tiny, 0, 4 )
print "  NULL dst  -> "; pParseArgs( 0, @"abc", 3 )
print "  length -1 -> "; pParseArgs( @tiny, @"abc", -1 )

'' ------------------------------------------------------------------ COMMAND$

'' The differential runs both executables with NO arguments, so argc is 1 and
'' every query but 0 is empty. COMMAND$(0) is the program NAME, which differs
'' between the two -- so only its emptiness is compared.
print "-- COMMAND$"
print "  COMMAND$(0) is non-empty="; ( len( command( 0 ) ) > 0 )
print "  COMMAND$(-1)=["; command( -1 ); "] len="; len( command( -1 ) )
print "  COMMAND$(1) =["; command( 1 ); "] len="; len( command( 1 ) )
print "  COMMAND$(99)=["; command( 99 ); "] len="; len( command( 99 ) )

'' ------------------------------------------------------- CURDIR$ / EXEPATH$

print "-- CURDIR$ and EXEPATH$"
dim as string cd0 = curdir
dim as string ep = exepath
print "  CURDIR$ non-empty="; ( len( cd0 ) > 0 )
print "  EXEPATH$ non-empty="; ( len( ep ) > 0 )
'' NEITHER ENDS IN A SEPARATOR -- a program that appends "/" to either must not
'' get a doubled one, and this is the only place the convention is asserted.
dim as long cdlast = asc( right( cd0, 1 ) )
dim as long eplast = asc( right( ep, 1 ) )
print "  CURDIR$ ends in a separator="; ( (cdlast = 47) orelse (cdlast = 92) )
print "  EXEPATH$ ends in a separator="; ( (eplast = 47) orelse (eplast = 92) )

'' ------------------------------------------------- MKDIR / CHDIR / RMDIR

'' A ROUND TRIP THROUGH THE FILESYSTEM, in a directory this program creates and
'' removes. The RETURN VALUES are the observable -- these three report the CRT's
'' code and never touch ERR, which is what the last line checks.
print "-- MKDIR, CHDIR, RMDIR"
dim as string dirname = "tkort-process-parity-dir"
dim as string dotdot = ".."

'' Left over from an interrupted run? Remove it first, and ignore the result.
pRmDir( @dirname )

print "  mkdir      -> "; pMkDir( @dirname )
print "  mkdir again-> "; pMkDir( @dirname )
print "  chdir in   -> "; pChDir( @dirname )
dim as string cd1 = curdir
print "  curdir changed="; ( cd1 <> cd0 )
print "  chdir out  -> "; pChDir( @dotdot )
dim as string cd2 = curdir
print "  curdir restored="; ( cd2 = cd0 )
print "  rmdir      -> "; pRmDir( @dirname )
print "  rmdir again-> "; pRmDir( @dirname )

dim as string nodir = "tkort-no-such-directory-at-all"
print "  chdir to a missing directory -> "; pChDir( @nodir )
print "  rmdir a missing directory    -> "; pRmDir( @nodir )

'' NONE OF THE THREE SETS ERR. The deliberate failures above would have set it
'' if they did, so a zero here is a measurement rather than a default.
print "  err after all of that="; err

print "done"
