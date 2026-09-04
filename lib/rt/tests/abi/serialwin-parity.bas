'' serialwin-parity.bas -- the Windows serial driver. Five symbols, one fbc
'' member (win32/io_serial.o).
''
'' NEEDS-GEN-LLVM
''
'' ALL FIVE ARE ADDRESS ONLY, and unlike most such files the reason is the same
'' for every one of them: they all take a W32_SERIAL_INFO that only
'' fb_SerialOpen can produce, and fb_SerialOpen acquires a real COM port.
''
''   fb_SerialOpen           CreateFileA on "COM1:" with EXCLUSIVE share mode.
''                           On a machine with a real COM1 that takes the port
''                           away from whatever else wanted it; on one without,
''                           it fails. WHICH of those happens depends on the
''                           hardware, so the output would vary by machine while
''                           looking deterministic in the source.
''   fb_SerialRead/Write     dereference pInfo->hDevice and pInfo->pOptions.
''   fb_SerialGetRemaining   same, plus ClearCommError on that handle.
''   fb_SerialClose          CloseHandle then free() on that block.
''
'' Passing NULL to any of the last four is not a test, it is a segfault: none of
'' them checks the pointer, exactly as fbc's do not.
''
'' WHAT IS ACTUALLY VERIFIED HERE is that the five symbols resolve, are
'' distinct, and carry the undecorated names the archive uses -- plus, in the
'' SOURCE rather than at run time, four #asserts that are the real content of
'' this batch:
''
''     sizeof( DCB_ )              = 28
''     sizeof( COMMTIMEOUTS_ )     = 20
''     sizeof( COMSTAT_ )          = 12
''     sizeof( FB_SERIAL_OPTIONS ) = 68
''
'' Those are compile-time and they are what a wrong struct layout trips on. The
'' DCB's fifteen bitfields packed into one DWORD cannot be checked that way
'' though: a wrong BIT ORDER has the right size, compiles, opens the port, and
'' silently configures the wrong handshake. Nothing here catches that and
'' nothing in fbc's suite does either -- it needs a real port and a scope.
''
'' SO THIS BATCH RESTS ON THE BIT LAYOUT BEING TRANSCRIBED CORRECTLY FROM THE
'' SDK HEADER, and that is stated plainly rather than implied by a passing test.

#include once "fbc-int/string.bi"

#ifdef __FB_WIN32__

extern "c"
	declare function pOpen alias "fb_SerialOpen" _
		( byval handle as any ptr, byval iPort as long, byval options as any ptr, _
		  byval pszDevice as zstring ptr, byval ppvHandle as any ptr ptr ) as long
	declare function pRead alias "fb_SerialRead" _
		( byval handle as any ptr, byval pvHandle as any ptr, _
		  byval data_ as any ptr, byval pLength as uinteger ptr ) as long
	declare function pWrite alias "fb_SerialWrite" _
		( byval handle as any ptr, byval pvHandle as any ptr, _
		  byval data_ as any ptr, byval length_ as uinteger ) as long
	declare function pRemaining alias "fb_SerialGetRemaining" _
		( byval handle as any ptr, byval pvHandle as any ptr, byval pLength as longint ptr ) as long
	declare function pClose alias "fb_SerialClose" _
		( byval handle as any ptr, byval pvHandle as any ptr ) as long
end extern

print "-- resolution"
dim shared as any ptr a5( 0 to 4 )
a5(0) = cast( any ptr, @pOpen )
a5(1) = cast( any ptr, @pRead )
a5(2) = cast( any ptr, @pWrite )
a5(3) = cast( any ptr, @pRemaining )
a5(4) = cast( any ptr, @pClose )

dim as long n = 0, distinct = 1
for i as integer = 0 to 4
	if( a5(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( a5(i) = a5(j) ) then distinct = 0
	next
next
print "  count="; n; " distinct="; distinct
print "  ALL FIVE ARE ADDRESS ONLY -- they need a real COM port; see the header"

#else

print "-- resolution"
print "  win32/io_serial.o is EMPTY-ON linux-x86_64; the POSIX driver is fbc's"

#endif

print "done"
