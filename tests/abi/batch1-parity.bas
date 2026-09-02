'' batch1-parity.bas -- fb_hScancodeToExtendedKey, fb_InitSignals and
'' fb_ConsoleReadStr. Three symbols across three fbc members.
''
'' NEEDS-GEN-LLVM
''
'' ONE OF THE THREE IS DRIVEN COMPLETELY, and the other two barely at all --
'' which is the honest split rather than a convenient one:
''
''   fb_hScancodeToExtendedKey  PURE. Every scancode from 0 to 0x60 is mapped and
''                              printed, so the whole table and its zero default
''                              are covered in one sweep.
''   fb_InitSignals             INSTALLS PROCESS-WIDE SIGNAL HANDLERS AND NEVER
''                              RESTORES THEM. Calling it would rewire SIGSEGV,
''                              SIGABRT and SIGINT for the rest of the run --
''                              including for the harness's own failure
''                              detection, which relies on a crashing test
''                              exiting non-zero. Proved by ADDRESS only.
''   fb_ConsoleReadStr          READS STDIN, AND IS PROVED BY ADDRESS ONLY.
''                              An earlier version of this file called it,
''                              reasoning that stdin under the harness is a pipe
''                              at EOF so fgets would return NULL at once. It did
''                              -- on the first run. On a later one it BLOCKED,
''                              and the differential hung for twenty minutes with
''                              the stock side finished and no -rt output at all.
''                              Whether stdin is at EOF is a property of how the
''                              harness was invoked, not of the runtime, so the
''                              call is not a test of anything and is a reliable
''                              way to wedge the suite. Removed.
''
'' THE SCANCODE SWEEP IS THE POINT OF THIS FILE. The mapping looks like an
'' identity -- KEY_F1 is FB_MAKE_EXT_KEY( ';' ) and ';' is 0x3B, which is
'' SC_F1 -- and that coincidence holds for every entry in the table. So an
'' implementation that computed `(scancode << 8) + 255` instead of looking the
'' letter up would agree on every mapped code AND on every unmapped one it
'' happened to be asked about. Sweeping the WHOLE range is what separates them:
'' the computed version returns non-zero for scancodes the table leaves at zero,
'' and there are forty of those below 0x60.

#include once "fbc-int/string.bi"

extern "c"
	declare function pScan alias "fb_hScancodeToExtendedKey" ( byval sc as long ) as long
	declare function pLptWrite  alias "fb_DevLptWrite" _
		( byval h as any ptr, byval v as any ptr, byval l as uinteger ) as long
	declare function pLptWriteW alias "fb_DevLptWriteWstr" _
		( byval h as any ptr, byval v as wstring ptr, byval l as uinteger ) as long
	declare function pLptClose  alias "fb_DevLptClose" ( byval h as any ptr ) as long
	declare function pReadStr alias "fb_ConsoleReadStr" _
		( byval buf as zstring ptr, byval l as integer ) as zstring ptr
end extern

extern "rtlib"
	declare sub pInitSignals alias "fb_InitSignals" ( )
end extern

print "-- resolution"
print "  all three distinct="; _
      ( (cast( any ptr, @pScan ) <> cast( any ptr, @pReadStr )) andalso _
        (cast( any ptr, @pScan ) <> cast( any ptr, @pInitSignals )) andalso _
        (cast( any ptr, @pReadStr ) <> cast( any ptr, @pInitSignals )) )
print "  fb_InitSignals: proved by ADDRESS ONLY -- it rewires the process's"
print "                  signal handlers permanently. See the file header."

'' ------------------------------------------- fb_hScancodeToExtendedKey

'' THE WHOLE RANGE, mapped and unmapped alike -- see the file header on why a
'' sample would not distinguish a table from a formula.
print "-- fb_hScancodeToExtendedKey, full sweep 0..0x60"
dim as long mapped = 0, zeroes = 0
for sc as long = 0 to &h60
	dim as long k = pScan( sc )
	if( k <> 0 ) then
		mapped += 1
		print "  sc="; hex( sc, 2 ); " -> "; hex( k, 4 );
		'' THE LOW BYTE IS ALWAYS THE MARKER, on every mapped entry.
		print "  low byte="; (k and &hFF); " high="; hex( (k shr 8) and &hFF, 2 )
	else
		zeroes += 1
	end if
next
print "  mapped="; mapped; " zero="; zeroes

'' THE COINCIDENCE, MADE EXPLICIT. For every mapped scancode the high byte of the
'' key equals the scancode itself -- which is exactly why a formula would pass a
'' spot check. Printed as a single boolean so a future change that breaks it is
'' one line of diff rather than twenty.
dim as long coincides = 1
for sc as long = 0 to &h60
	dim as long k = pScan( sc )
	if( k <> 0 ) then
		if( ((k shr 8) and &hFF) <> sc ) then coincides = 0
	end if
next
print "  high byte = scancode for every mapped entry="; coincides
print "  (so a formula would agree on all of them -- the ZERO count is the test)"

'' NEGATIVE AND OUT-OF-RANGE are zero, and are asked for explicitly because the
'' sweep above cannot reach them.
print "  sc=-1     -> "; pScan( -1 )
print "  sc=-32768 -> "; pScan( -32768 )
print "  sc=0x61   -> "; pScan( &h61 )
print "  sc=0xFF   -> "; pScan( &hFF )
print "  sc=0x7FFFFFFF -> "; pScan( &h7FFFFFFF )

'' F11 AND F12 HAVE SCANCODES AND KEYS AND NO ENTRY -- 0x57 and 0x58 return zero,
'' which is fbc's behaviour and the one place the table is deliberately short.
print "  sc=0x57 (F11) -> "; pScan( &h57 ); "   (has a key, no entry -- fbc's)"
print "  sc=0x58 (F12) -> "; pScan( &h58 ); "   (same)"

'' ------------------------------------------------------ fb_ConsoleReadStr

'' NOT CALLED. See the file header: it blocks when stdin is not at EOF, which
'' is a property of the harness's invocation rather than of either runtime, and
'' a hung differential is worse than an uncovered entry point.
print "-- fb_ConsoleReadStr (ADDRESS ONLY -- calling it can block on stdin)"
print "  resolves="; ( cast( any ptr, @pReadStr ) <> 0 )

'' ------------------------------------------------ the printer wrappers

'' ADDRESS ONLY, and for a harder reason than usual: all three take a channel
'' whose `opaque` is a DEV_LPT_INFO the printer driver allocated. There is no way
'' to obtain one without OPENing a printer, which on Windows talks to the spooler
'' and on POSIX spawns lpr -- neither of which belongs in a differential, and
'' neither of which this machine is guaranteed to have.
''
'' Passing a hand-made structure instead would test tiko-rt's wrappers against
'' fbc's driver reading a pointer neither of them allocated, which is a crash
'' dressed up as a test.
print "-- the printer wrappers (ADDRESS ONLY -- they need a real spooler channel)"
print "  fb_DevLptWrite, WriteWstr and Close resolve and differ="; _
      ( (cast( any ptr, @pLptWrite ) <> 0) andalso _
        (cast( any ptr, @pLptWrite ) <> cast( any ptr, @pLptWriteW )) andalso _
        (cast( any ptr, @pLptWriteW ) <> cast( any ptr, @pLptClose )) andalso _
        (cast( any ptr, @pLptWrite ) <> cast( any ptr, @pLptClose )) )

print "done"
