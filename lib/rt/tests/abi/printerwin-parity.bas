'' printerwin-parity.bas -- the Windows printer driver. Four symbols, one fbc
'' member (win32/io_printer.o).
''
'' NEEDS-GEN-LLVM
''
'' ALL FOUR ARE ADDRESS ONLY, and the reason is the same one that makes
'' tests/abi/devcomopen-parity.bas address-only: the outcome depends on the
'' MACHINE, not on the runtime.
''
''   fb_PrinterOpen        enumerates every printer on the machine through the
''                         spooler, then either OpenPrinter's one or CreateDC's
''                         a device context and StartDoc's a real print job. On
''                         a machine with a printer that queues a document; on
''                         one without it returns FILENOTFOUND. Both runtimes
''                         would agree -- and the test would be exercising a
''                         different path on almost every machine it ran on,
''                         while looking deterministic in the source.
''   fb_PrinterWrite       dereferences devInfo->driver_opaque, which only
''   fb_PrinterWriteWstr   fb_PrinterOpen can produce. Passing NULL is a
''   fb_PrinterClose       segfault, not a test -- none of them checks it,
''                         exactly as fbc's do not.
''
'' WHAT ACTUALLY CARRIES THIS BATCH IS COMPILE-TIME, and it is worth listing
'' because a reader seeing four address-only symbols could reasonably conclude
'' nothing was checked:
''
''     sizeof( LOGFONTA_ )        = 60, lfCharSet at 23, lfFaceName at 28
''     sizeof( TEXTMETRICA_ )     = 56, tmMaxCharWidth at 24
''     sizeof( DOCINFOA_ )        = 40, lpszDocName at 8      (win64)
''     sizeof( DOC_INFO_1A_ )     = 24                        (win64)
''     sizeof( PRINTER_INFO_2A_ ) = 136, pPortName at 24      (win64)
''     sizeof( PRINTER_INFO_5A_ ) = 32                        (win64)
''     sizeof( DEV_LPT_PROTOCOL ) = 40 / 20
''
'' PRINTER_INFO_2A's SIZE IS THE LOAD-BEARING ONE. EnumPrinters returns an
'' ARRAY, so a wrong stride reads the second and later elements from the wrong
'' offsets -- which surfaces as a corrupt printer NAME, not as a crash, and
'' would look like a spooler problem rather than a layout bug.
''
'' AND THE win32 LAYOUTS ARE NOT MEASURED. There are no i686 headers on this
'' machine, so the pointer-bearing structs are asserted on win64 only and win32
'' follows from FreeBASIC's natural layout rules. That is a real gap: it is
'' sound for these particular structs -- every one is a run of pointers followed
'' by a run of DWORDs, with no bitfields and no unions -- but it is reasoning
'' rather than measurement, and the day someone adds a struct here that is not
'' that shape, this comment is the warning.

#include once "fbc-int/string.bi"

#ifdef __FB_WIN32__

extern "c"
	declare function pOpen alias "fb_PrinterOpen" _
		( byval devInfo as any ptr, byval iPort as long, byval pszDevice as zstring ptr ) as long
	declare function pWrite alias "fb_PrinterWrite" _
		( byval devInfo as any ptr, byval data_ as any ptr, byval length_ as uinteger ) as long
	declare function pWriteWstr alias "fb_PrinterWriteWstr" _
		( byval devInfo as any ptr, byval data_ as wstring ptr, byval length_ as uinteger ) as long
	declare function pClose alias "fb_PrinterClose" ( byval devInfo as any ptr ) as long
end extern

print "-- resolution"
dim shared as any ptr a4( 0 to 3 )
a4(0) = cast( any ptr, @pOpen )
a4(1) = cast( any ptr, @pWrite )
a4(2) = cast( any ptr, @pWriteWstr )
a4(3) = cast( any ptr, @pClose )

dim as long n = 0, distinct = 1
for i as integer = 0 to 3
	if( a4(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( a4(i) = a4(j) ) then distinct = 0
	next
next
print "  count="; n; " distinct="; distinct
print "  ALL FOUR ARE ADDRESS ONLY -- they queue real print jobs; see the header"

'' THE POSIX HALF MUST NOT BE HERE. printerposix.tiko is EMPTY-ON Windows and
'' this file is EMPTY-ON Linux, so exactly one of the two provides these four
'' symbols on any given target -- and if both ever did, the archive would have
'' duplicate definitions and the link would fail rather than pick one.
print "  (the POSIX driver is EMPTY-ON this target, so these are printerwin's)"

#else

print "-- resolution"
print "  win32/io_printer.o is EMPTY-ON linux-x86_64; see printerposix.tiko"

#endif

print "done"
