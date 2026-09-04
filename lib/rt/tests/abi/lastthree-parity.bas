'' lastthree-parity.bas -- fb_ExecEx, fb_WidthDev and __fb_enable_vt100_escapes:
'' the last three portable members. Three symbols across three fbc members.
''
'' NEEDS-GEN-LLVM
''
'' TWO OF THE THREE HAVE SIDE EFFECTS ON THE MACHINE, and the cases below are
'' chosen so that neither one does anything a developer would mind:
''
''   fb_ExecEx    SPAWNS A PROCESS. Every case here either fails before spawning
''                (a NULL program, a path that does not exist) or runs a shell
''                built-in that exits immediately with a known code. Nothing is
''                written, nothing is deleted, and do_fork is TRUE everywhere --
''                see below on why FALSE cannot be tested.
''   fb_WidthDev  WRITES INTO A PROCESS-WIDE REGISTRY that is never freed, and
''                for SCRN: it RESIZES THE CONSOLE. Only the QUERY form is used
''                on SCRN:; the setting cases use invented device names, which
''                reach the list and nothing else.
''
'' do_fork = FALSE IS NOT TESTED, AND CANNOT BE. On POSIX it calls execvp
'' directly, which REPLACES THIS PROCESS -- the differential would compare a
'' truncated output against a truncated output and call them equal. On Windows
'' _execl does the same. There is no way to drive that path from inside the
'' program under test, and saying so is better than a case that silently proves
'' nothing.
''
'' THE EXIT CODE IS THE COMPARISON, not the child's output. The child writes to
'' the same stdout the harness is capturing, so anything it printed would land
'' in the compared stream and agree for reasons unrelated to fb_ExecEx. The
'' commands chosen produce no output.
''
'' AND THE 255 AMBIGUITY IS DELIBERATELY EXERCISED. fbc's POSIX path uses exit
'' code 255 to signal "execvp failed" and maps it back to -1, which means a child
'' that genuinely returns 255 is indistinguishable from a failed spawn. The case
'' below asks for exactly 255 so that the ambiguity is visible in the output
'' rather than latent -- both runtimes must be ambiguous in the same way.
''
'' __fb_enable_vt100_escapes IS POSIX-ONLY and is read, not written. Its whole
'' contract is that an FB program may define its own and have the linker prefer
'' it, which a differential cannot test from inside one program -- proving that
'' would need a second object defining the symbol, and then the case would be
'' testing the linker. The value and the address are what is compared here, and
'' the limit is stated.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pExecEx alias "fb_ExecEx" _
		( byval prog as any ptr, byval args as any ptr, byval do_fork as long ) as long
	declare function pWidthDev alias "fb_WidthDev" _
		( byval dev as any ptr, byval w as long ) as long
end extern

#ifndef __FB_WIN32__
	extern "c"
		extern __fb_enable_vt100_escapes alias "__fb_enable_vt100_escapes" as long
	end extern
#endif

print "-- resolution"
print "  fb_ExecEx and fb_WidthDev distinct="; _
      ( cast( any ptr, @pExecEx ) <> cast( any ptr, @pWidthDev ) )

'' ------------------------------------------------------------ fb_WidthDev

'' THE ARGUMENT CHOOSES THE MEANING OF THE RETURN: -1 queries and returns the
'' width, anything else sets and returns an error code. Both are printed with
'' the argument beside them so the two cannot be confused when reading output.
print "-- fb_WidthDev"

sub tryWidth( byref dev as string, byval w as long )
	dim as string d = dev
	dim as long r = pWidthDev( @d, w )
	print "  ["; dev; "] w="; w; " -> "; r;
	if( w = -1 ) then print "   (query: the width)" else print "   (set: an error code)"
end sub

'' AN INVENTED DEVICE reaches the registry and none of the three real devices,
'' so it is the clean test of the list itself: set, then query back.
tryWidth( "TKORTTEST:", -1 )        '' never seen -> returns the -1 it was given
tryWidth( "TKORTTEST:", 42 )        '' set
tryWidth( "TKORTTEST:", -1 )        '' query -> 42
tryWidth( "TKORTTEST:", 77 )        '' overwrite the existing node
tryWidth( "TKORTTEST:", -1 )        '' query -> 77

'' A SECOND NAME, to prove the list holds more than one and that the lookup
'' actually compares rather than returning the head.
tryWidth( "TKORTOTHER:", -1 )
tryWidth( "TKORTOTHER:", 13 )
tryWidth( "TKORTOTHER:", -1 )
tryWidth( "TKORTTEST:", -1 )        '' still 77 -- the other node did not clobber it

'' THE NAME IS UPPER-CASED BEFORE THE LOOKUP, so these three are one device.
tryWidth( "tkortcase:", 99 )
tryWidth( "TKORTCASE:", -1 )
tryWidth( "TkOrTcAsE:", -1 )

'' SCRN: IS QUERIED ONLY -- setting it resizes the console. The value is the
'' handle's own width, not the registry's, which is the branch worth reaching.
tryWidth( "SCRN:", -1 )

'' AN EMPTY NAME. strptr( "" ) is NULL, but FB_STRSIZE of the descriptor is 0 and
'' the copy is a bare terminator, so this is a legal zero-length device that
'' matches nothing.
dim shared as string emptydev
emptydev = ""
print "  [<empty>] w=-1 -> "; pWidthDev( @emptydev, -1 )

'' ------------------------------------------------------------- fb_ExecEx

print "-- fb_ExecEx (do_fork=TRUE only; FALSE replaces the process -- see header)"

'' A NULL PROGRAM FAILS BEFORE ANYTHING IS SPAWNED, and consumes both arguments.
print "  null program        -> "; pExecEx( 0, 0, -1 )

'' A PROGRAM THAT DOES NOT EXIST. Windows' _spawnl returns -1; POSIX's execvp
'' fails in the child, which _exit(255)s, and the parent maps 255 back to -1.
'' Two completely different routes to the same answer.
dim shared as string noprog, noargs
noprog = "tkort-no-such-program-12345"
noargs = ""
print "  missing program     -> "; pExecEx( @noprog, @noargs, -1 )

'' A REAL PROGRAM WITH A KNOWN EXIT CODE. The shell is used because it exists on
'' both platforms and its `exit` built-in produces no output.
dim shared as string sh, shargs
#ifdef __FB_WIN32__
	sh = environ( "COMSPEC" )
	if( len( sh ) = 0 ) then sh = "C:\Windows\System32\cmd.exe"
	shargs = "/c exit 7"
#else
	sh = "/bin/sh"
	shargs = "-c ""exit 7"""
#endif
print "  shell, exit 7       -> "; pExecEx( @sh, @shargs, -1 )

'' EXIT CODE ZERO, so a success is distinguishable from the -1 above.
dim shared as string shargs0
#ifdef __FB_WIN32__
	shargs0 = "/c exit 0"
#else
	shargs0 = "-c ""exit 0"""
#endif
dim shared as string sh2
sh2 = sh
print "  shell, exit 0       -> "; pExecEx( @sh2, @shargs0, -1 )

'' AND 255, WHICH IS THE AMBIGUOUS ONE. On POSIX this is indistinguishable from a
'' failed exec and comes back as -1; on Windows it is just 255. Both runtimes
'' must agree with their own platform -- see the file header.
dim shared as string sh3, shargs255
sh3 = sh
#ifdef __FB_WIN32__
	shargs255 = "/c exit 255"
#else
	shargs255 = "-c ""exit 255"""
#endif
print "  shell, exit 255     -> "; pExecEx( @sh3, @shargs255, -1 ); _
      "   (POSIX maps 255 to -1: the documented ambiguity)"

'' NULL ARGUMENTS, which takes the `args = 0` branch rather than the copy --
'' paired with a program that does NOT EXIST, deliberately.
''
'' Passing NULL args to the real shell launched it INTERACTIVELY and it printed
'' its banner into the stream the harness compares:
''
''     null args -> Microsoft Windows [Version 10.0.26200.9168]
''
'' The two runtimes agreed on that, because both runs are on the same machine --
'' so the case passed while embedding this machine's Windows build number in the
'' expected output, and while depending on an interactive shell reaching EOF on
'' a pipe rather than waiting for input. A missing program reaches the same
'' `args = 0` branch and then fails before anything can print.
dim shared as string noprog2
noprog2 = "tkort-no-such-program-67890"
print "  null args           -> "; pExecEx( @noprog2, 0, -1 )

'' -------------------------------------------- __fb_enable_vt100_escapes

#ifndef __FB_WIN32__
	print "-- __fb_enable_vt100_escapes"
	'' MINUS ONE, not one: fbc initialises it to FB_TRUE's spelling, and the
	'' value is compared rather than merely its truthiness.
	print "  value="; __fb_enable_vt100_escapes
	print "  is -1="; ( __fb_enable_vt100_escapes = -1 )
	print "  address is stable="; ( @__fb_enable_vt100_escapes = @__fb_enable_vt100_escapes )
	'' THE OVERRIDE CONTRACT IS NOT TESTED HERE -- it needs a second object that
	'' defines the symbol, which would be testing the linker. See the header.
	print "  override semantics: NOT TESTED (needs a second object)"
#else
	print "-- __fb_enable_vt100_escapes: POSIX ONLY, not present on this target"
#endif

print "done"
