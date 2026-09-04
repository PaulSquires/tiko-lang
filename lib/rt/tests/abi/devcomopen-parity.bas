'' devcomopen-parity.bas -- the COMx device and its option-string parser. Two
'' symbols, one fbc member (dev_com.o).
''
'' NEEDS-GEN-LLVM
''
'' fb_DevComOpen CANNOT BE CALLED and the reason is not squeamishness: on
'' Windows it ends in CreateFile on \\.\COMn and on POSIX in open() on a tty
'' device node. On a machine with a real COM1 that acquires the port; on one
'' without, it fails -- and WHICH of those happens depends on the hardware, so
'' the differential's output would depend on the machine in a way that is
'' invisible in the source. Both sides would still agree, but the test would be
'' silently testing nothing on most machines and something else on others. Its
'' address is checked and that is all.
''
'' fb_DevSerialSetWidth IS CALLED, and it reaches everything except the branch
'' that needs an open port: fb_DevComTestProtocolEx parses for real, the
'' canonical "COMn:" name is rebuilt with sprintf for real, and the search walks
'' all FB_MAX_FILES entries comparing hook-table addresses for real. Only the
'' "found one" arm is unreachable.
''
'' WHAT THE CALLS PIN:
''
''   A FAILED PARSE RETURNS 0, NOT AN ERROR. That is the OPPOSITE of
''   fb_DevPrinterSetWidth in tests/abi/devlptopen-parity.bas, which returns
''   FB_RTERROR_ILLEGALFUNCTIONCALL for the same condition. Two functions with
''   the same name shape, the same three parameters, and different failure
''   conventions -- so the two tests are worth reading together, and this comment
''   is the only thing that will make anyone do so.
''
''   THE DEFAULT IS 0, NOT 80. A serial port does not wrap lines. Passing
''   default_width = -1 must give 0 here and 80 there.
''
''   PORT 0 IS REBUILT AS "COM0:". fb_DevComTestProtocolEx accepts device names
''   that are not "COMn" and reports port 0 for them; this function rebuilds the
''   name unconditionally as "COM%u:" and then searches for the literal "COM0:",
''   which nothing can ever be called. The open path has a second branch for
''   exactly that case and this one does not -- so a device path that opens fine
''   can never have its width read back.
''
'' THE OPTION PARSER IS THE INTERESTING HALF OF THIS MEMBER AND IT IS NOT
'' REACHED HERE AT ALL. Positional-then-named fields, the empty field that still
'' advances the counter, "PE" meaning two different things by position, the
'' stop-bit derivation that runs even after an error -- none of it runs without
'' an open, and all of it rests on fbc's suite. Saying so is the point of this
'' paragraph; the file would otherwise read as though the parser were covered.

#include once "fbc-int/string.bi"

extern "c"
	declare function pComOpen alias "fb_DevComOpen" _
		( byval handle as any ptr, byval filename as zstring ptr, _
		  byval filename_len as uinteger ) as long
	declare function pSetWidth alias "fb_DevSerialSetWidth" _
		( byval pszDevice as zstring ptr, byval width_ as long, byval default_width as long ) as long
end extern

print "-- resolution"
dim shared as any ptr a2( 0 to 1 )
a2(0) = cast( any ptr, @pComOpen )
a2(1) = cast( any ptr, @pSetWidth )
print "  count="; iif( a2(0) <> 0, 1, 0 ) + iif( a2(1) <> 0, 1, 0 ); _
      " distinct="; iif( a2(0) <> a2(1), 1, 0 )
print "  fb_DevComOpen is ADDRESS ONLY -- it acquires a real serial port"

dim shared as zstring * 96 dev

'' -------------------------------------------- fb_DevSerialSetWidth
''
'' THE DEFAULT IS ZERO. See the file header on why that differs from the
'' printer's 80.
print "-- ask, nothing open: the default is 0, not 80"
dev = "COM1:"  : print "  COM1:  (-1,-1) -> "; pSetWidth( @dev, -1, -1 )
dev = "com1:"  : print "  com1:  (-1,-1) -> "; pSetWidth( @dev, -1, -1 )
dev = "COM2:"  : print "  COM2:  (-1,-1) -> "; pSetWidth( @dev, -1, -1 )
dev = "COM9:"  : print "  COM9:  (-1,-1) -> "; pSetWidth( @dev, -1, -1 )

'' THE CALLER'S DEFAULT COMES BACK when nothing is found.
print "-- the caller's default is what 'not found' returns"
dev = "COM1:"
print "  default 0   -> "; pSetWidth( @dev, -1, 0 )
print "  default 40  -> "; pSetWidth( @dev, -1, 40 )
print "  default 132 -> "; pSetWidth( @dev, -1, 132 )

'' SETTING WITH NOTHING OPEN IS A NO-OP: the assignment lives inside the found
'' branch, so the answer is still the default.
print "-- setting with nothing open changes nothing"
print "  set 40, default -1 -> "; pSetWidth( @dev, 40, -1 )
print "  ask again          -> "; pSetWidth( @dev, -1, -1 )

'' A FAILED PARSE RETURNS 0 -- and so does a successful parse that finds
'' nothing with default_width 0. The two are indistinguishable, which is the
'' point of printing them next to each other.
print "-- parse failures return 0, and so does 'found nothing, default 0'"
dev = ""          : print "  empty          -> "; pSetWidth( @dev, -1, -1 )
dev = "COM1"      : print "  no colon       -> "; pSetWidth( @dev, -1, -1 )
dev = "NOSUCH:"   : print "  unknown proto  -> "; pSetWidth( @dev, -1, -1 )
dev = "LPT1:"     : print "  a PRINTER name -> "; pSetWidth( @dev, -1, -1 )
dev = "COM1:"     : print "  valid, default 0 -> "; pSetWidth( @dev, -1, 0 )

'' A DEVICE PATH PARSES BUT CAN NEVER BE FOUND -- see the file header on the
'' "COM0:" rebuild.
print "-- a non-COMn device name (port 0, rebuilt as COM0:)"
dev = "/dev/ttyS0:"    : print "  /dev/ttyS0: -> "; pSetWidth( @dev, -1, -1 )
dev = "\\.\COM10:"     : print "  \\.\COM10:  -> "; pSetWidth( @dev, -1, -1 )

'' WITH OPTIONS ATTACHED. The width query passes the WHOLE string to the
'' protocol test, options and all, so it has to tolerate them -- and does,
'' because the test stops at the colon.
print "-- option strings must not disturb the width query"
dev = "COM1:9600,N,8,1"           : print "  9600,N,8,1        -> "; pSetWidth( @dev, -1, -1 )
dev = "COM1:,,8"                  : print "  ,,8               -> "; pSetWidth( @dev, -1, -1 )
dev = "COM1:9600,N,8,1,CS0,DS0"   : print "  ...,CS0,DS0       -> "; pSetWidth( @dev, -1, -1 )
dev = "COM1:garbage,not,an,option": print "  garbage options   -> "; pSetWidth( @dev, -1, -1 )

'' REPEATED CALLS MUST NOT DRIFT. Each call parses and rebuilds; a corrupted
'' heap would surface as a changed answer. This is not a leak check and does not
'' claim to be one.
print "-- 200 repeats, answer must not drift"
dev = "COM1:"
dim as long stable = 1
for i as integer = 1 to 200
	if( pSetWidth( @dev, -1, -1 ) <> 0 ) then stable = 0
	if( pSetWidth( @dev, -1, 77 ) <> 77 ) then stable = 0
next
print "  stable="; stable

print "done"
