'' portio-parity.bas -- fb_hIn and fb_hOut, the back end of INP and OUT.
''
'' NEEDS-GEN-LLVM
''
'' THIS IS ONE OF THE FEW MEMBERS WHERE THE FAILURE PATH IS THE WHOLE CONTRACT,
'' so unlike the printer and serial batches this test is NOT address-only: on
'' win64 both entry points are unconditional stubs, and calling them is safe,
'' deterministic and exercises everything they do.
''
'' WHAT IS CHECKED IS THE SIGN. fb_hIn returns the byte read, so it has no spare
'' value for failure and reports one as a NEGATIVE error number; fb_hOut has
'' nothing else to return, so it reports the error number as-is. A copy-paste
'' between the two would leave INP( ) returning 1 -- a perfectly plausible port
'' reading -- on a machine with no port I/O at all. Printing both results is what
'' catches that, and printing only "it returned an error" would not.
''
'' fb_ErrorGetNum IS READ AFTERWARDS because fb_ErrorSetNum has a side effect as
'' well as a return value: it records the number for the ERR function. A stub
'' that returned the right constant without going through fb_ErrorSetNum would
'' agree on the first two lines and differ on the third.
''
'' ON win32 AND linux THESE ARE fbc's, and stay fbc's -- both compile a live
'' `inb`/`outb`, which -gen llvm rejects (error 374, probed). The test still runs
'' there, and what it then compares is the C runtime against ITSELF, which is
'' worth exactly nothing as evidence about tiko-rt. It is left in rather than
'' #if'd out for one reason: if a later batch ever DOES provide these on win32
'' or linux, this file starts testing it on the same run, with no edit and no
'' one having to remember. The header is here so nobody mistakes the green line
'' on those targets for coverage.

#include once "fbc-int/string.bi"

extern "c"
	declare function hIn alias "fb_hIn" ( byval port as ushort ) as long
	declare function hOut alias "fb_hOut" _
		( byval port as ushort, byval value_ as ubyte ) as long
end extern

extern "rtlib"
	declare function errGetNum alias "fb_ErrorGetNum" ( ) as long
end extern

#if defined( __FB_WIN32__ ) and defined( __FB_64BIT__ )
print "-- win64: both are unconditional stubs, so they are CALLED"

'' Port 0x3F8 is COM1's data register -- a real port number, chosen so the test
'' is not relying on the argument being rejected as out of range. Nothing
'' reaches the hardware: the stub returns before any instruction is issued.
dim as long r = hIn( &h3F8 )
print "  fb_hIn( &h3F8 )      = "; r; "   (NEGATIVE: the byte read has no spare value)"
print "  err after            = "; errGetNum( )

dim as long w = hOut( &h3F8, &h41 )
print "  fb_hOut( &h3F8, 65 ) = "; w; "   (POSITIVE: nothing to return but status)"
print "  err after            = "; errGetNum( )

'' CALLED TWICE to show the stub is stateless -- fbc's win32 half caches an
'' `inited` flag and only initialises once, and a port of the WRONG arm would
'' plausibly answer differently the second time.
print "  second call, hIn     = "; hIn( &h3F8 )
print "  second call, hOut    = "; hOut( &h3F8, &h42 )

#else
print "-- not win64: ADDRESS ONLY, and calling these here would be RECKLESS"

'' NOT CALLED, and the reason is worth spelling out because "it just returns an
'' error without privileges" is the tempting and wrong reading. On win32 the
'' first call to fb_hIn runs init_ports, which OpenSCManager's the service
'' database, WRITES a 5,632-byte kernel driver into
'' %SystemRoot% System32 Drivers as fbportio.sys, registers it as a service and
'' tries to start it. It only FAILS at the end, after doing all of that. A test
'' suite must not install a kernel driver on the machine running it, and a test
'' that did would leave a service behind whether it passed or not.
''
'' On linux the call is harmless (it checks __fb_con.has_perm and returns), but
'' it is left out for symmetry: nothing on either target would be evidence about
'' tiko-rt, which provides neither.
dim shared as any ptr a2( 0 to 1 )
a2(0) = cast( any ptr, @hIn )
a2(1) = cast( any ptr, @hOut )
print "  count="; -((a2(0) <> 0) + (a2(1) <> 0)); " distinct="; -(a2(0) <> a2(1))
print "  (fbc's live inb/outb; -gen llvm rejects it -- error 374, probed)"
#endif

print "done"
