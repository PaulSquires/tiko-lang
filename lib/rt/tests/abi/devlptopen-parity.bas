'' devlptopen-parity.bas -- opening an LPT device and the two LPRINT queries.
'' Three symbols, one fbc member (dev_lpt.o).
''
'' NEEDS-GEN-LLVM
''
'' TWO OF THE THREE ARE SAFE TO CALL AND ARE CALLED PROPERLY. With no printer
'' open, fb_DevPrinterSetWidth and fb_DevPrinterGetOffset parse the device
'' string, rebuild its canonical "proto:name" form, search the whole file table,
'' find nothing and return a default. Every step but the last runs for real --
'' the parser, the allocation, the search over all FB_MAX_FILES entries and the
'' frees -- so this exercises the entire function except the branch that needs
'' hardware.
''
'' fb_DevLptOpen IS NOT CALLED. It ends in fb_PrinterOpen, which on Windows
'' reaches the spooler and on POSIX opens a device node; either way it acquires
'' a real printer and leaves a handle in __fb_ctx.fileTB that outlives the test.
'' Its address is checked and that is all.
''
'' WHAT THE TWO CALLS ACTUALLY PIN:
''
''   THE PARSE FAILURE PATH. A device string the protocol parser rejects returns
''   FB_RTERROR_ILLEGALFUNCTIONCALL (1) rather than a width, so the SAME return
''   channel carries both an error code and a column count. 1 is a plausible
''   width, which is exactly why this is worth a test: a caller cannot tell them
''   apart and neither can a reader.
''
''   THE DEFAULT. width = -1 asks rather than sets; default_width = -1 means 80.
''   Any other default_width is returned verbatim when no printer is found, so
''   the "not found" answer is the CALLER'S default and not a constant.
''
''   THE OFFSET DEFAULT IS ZERO, and zero is also a perfectly good answer for a
''   printer sitting at the start of a line. fbc conflates the two; so does this.
''
''   CASE MATTERS. The search compares the rebuilt name with strcmp and the
''   parser does not upcase, so "LPT1:" and "lpt1:" are different devices. Both
''   are asked for below -- they agree here only because neither is open, and
''   the point is that the PARSE accepts both.
''
'' NO PRINTER IS OPEN DURING ANY OF THIS, which is the assumption the whole file
'' rests on. If one were, these calls would report its width instead of the
'' default and the test would still pass -- both runtimes would see the same
'' printer -- so the assumption affects what is COVERED, not whether the
'' comparison is valid.

#include once "fbc-int/string.bi"

extern "c"
	declare function pLptOpen alias "fb_DevLptOpen" _
		( byval handle as any ptr, byval filename as zstring ptr, _
		  byval filename_len as uinteger ) as long
	declare function pSetWidth alias "fb_DevPrinterSetWidth" _
		( byval pszDevice as zstring ptr, byval width_ as long, byval default_width as long ) as long
	declare function pGetOffset alias "fb_DevPrinterGetOffset" _
		( byval pszDevice as zstring ptr ) as long
end extern

print "-- resolution"
dim shared as any ptr a3( 0 to 2 )
a3(0) = cast( any ptr, @pLptOpen )
a3(1) = cast( any ptr, @pSetWidth )
a3(2) = cast( any ptr, @pGetOffset )
dim as long n = 0, distinct = 1
for i as integer = 0 to 2
	if( a3(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( a3(i) = a3(j) ) then distinct = 0
	next
next
print "  count="; n; " distinct="; distinct
print "  fb_DevLptOpen is ADDRESS ONLY -- it acquires a real printer"

'' The device strings are held as real objects: the functions take a zstring ptr
'' and call strlen on it, so a literal's address is not what is wanted here.
dim shared as zstring * 64 dev

'' ------------------------------------------------- fb_DevPrinterSetWidth
''
'' ASKING (width = -1) WITH THE DEFAULT DEFAULT (-1) MUST GIVE 80.
print "-- fb_DevPrinterSetWidth: ask, no printer open"
dev = "LPT1:"    : print "  LPT1:  (-1,-1) -> "; pSetWidth( @dev, -1, -1 )
dev = "lpt1:"    : print "  lpt1:  (-1,-1) -> "; pSetWidth( @dev, -1, -1 )
dev = "LPT:"     : print "  LPT:   (-1,-1) -> "; pSetWidth( @dev, -1, -1 )
dev = "LPT2:"    : print "  LPT2:  (-1,-1) -> "; pSetWidth( @dev, -1, -1 )
dev = "PRN:"     : print "  PRN:   (-1,-1) -> "; pSetWidth( @dev, -1, -1 )

'' THE CALLER'S DEFAULT COMES BACK, not 80 -- see the file header.
print "-- the caller's default is what 'not found' returns"
dev = "LPT1:"
print "  default 40  -> "; pSetWidth( @dev, -1, 40 )
print "  default 132 -> "; pSetWidth( @dev, -1, 132 )
print "  default 0   -> "; pSetWidth( @dev, -1, 0 )
print "  default 1   -> "; pSetWidth( @dev, -1, 1 )

'' SETTING WITH NO PRINTER OPEN CHANGES NOTHING and still returns the default,
'' because the assignment happens inside the found branch.
print "-- setting with nothing open is a no-op"
print "  set 40, default -1 -> "; pSetWidth( @dev, 40, -1 )
print "  ask again          -> "; pSetWidth( @dev, -1, -1 )

'' THE PARSE FAILURE PATH. 1 is FB_RTERROR_ILLEGALFUNCTIONCALL and is also a
'' plausible width -- see the file header.
print "-- parse failures return 1, which is also a plausible width"
dev = ""         : print "  empty         -> "; pSetWidth( @dev, -1, -1 )
dev = "LPT1"     : print "  no colon      -> "; pSetWidth( @dev, -1, -1 )
dev = ":"        : print "  bare colon    -> "; pSetWidth( @dev, -1, -1 )
dev = "NOSUCH:"  : print "  unknown proto -> "; pSetWidth( @dev, -1, -1 )
dev = "LPT1:x"   : print "  trailing text -> "; pSetWidth( @dev, -1, -1 )

'' ------------------------------------------------ fb_DevPrinterGetOffset

print "-- fb_DevPrinterGetOffset: zero means both 'no printer' and 'column 0'"
dev = "LPT1:"    : print "  LPT1:  -> "; pGetOffset( @dev )
dev = "lpt1:"    : print "  lpt1:  -> "; pGetOffset( @dev )
dev = "LPT:"     : print "  LPT:   -> "; pGetOffset( @dev )
dev = "PRN:"     : print "  PRN:   -> "; pGetOffset( @dev )

print "-- fb_DevPrinterGetOffset parse failures"
dev = ""         : print "  empty         -> "; pGetOffset( @dev )
dev = "LPT1"     : print "  no colon      -> "; pGetOffset( @dev )
dev = "NOSUCH:"  : print "  unknown proto -> "; pGetOffset( @dev )

'' REPEATED CALLS MUST NOT DRIFT. Each call allocates a protocol block and a
'' device name and frees both; a missing free would not show up as a wrong
'' answer, so the only thing a test can do here is prove the ANSWER is stable
'' over enough iterations that a corrupted heap would surface. It is not a leak
'' check and it does not pretend to be one.
print "-- 200 repeats, answer must not drift"
dev = "LPT1:"
dim as long stable = 1
for i as integer = 1 to 200
	if( pSetWidth( @dev, -1, -1 ) <> 80 ) then stable = 0
	if( pGetOffset( @dev ) <> 0 ) then stable = 0
next
print "  stable="; stable

print "done"
