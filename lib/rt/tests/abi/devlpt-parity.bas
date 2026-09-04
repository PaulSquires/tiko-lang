'' devlpt-parity.bas -- the LPT device-string parser. Two entry points across one
'' fbc member.
''
'' NEEDS-GEN-LLVM
''
'' THIS ONE IS PURE, so it is driven completely: a string in, a struct out, one
'' free. No printer, no spooler, nothing that can block -- unlike every other
'' entry point in the LPT family, which is why lprint-parity had to prove its
'' fifteen by address and this file proves its two by result.
''
'' ALL FOUR STRING FIELDS ARE PRINTED FOR EVERY CASE, including the ones that
'' were never given: an absent field must read as the EMPTY STRING and not as
'' NULL, which is the point of initialising all four to the terminator. Printing
'' only the fields a case sets would miss exactly that.

#include once "fbc-int/string.bi"

'' fb_printer.h's DEV_LPT_PROTOCOL header. `char raw[]` is a flexible array
'' member and is not modelled -- the four pointers point into it.
type LptProto
	as zstring ptr proto
	as long        iPort
	as zstring ptr name_
	as zstring ptr title_
	as zstring ptr emu
end type

#if defined( __FB_64BIT__ )
	#assert sizeof( LptProto ) = 40
#else
	#assert sizeof( LptProto ) = 20
#endif

extern "c"
	declare function pParse alias "fb_DevLptParseProtocol" _
		( byval outp as LptProto ptr ptr, byval raw_ as zstring ptr, _
		  byval l as uinteger, byval subst as long ) as long
	declare function pTest alias "fb_DevLptTestProtocol" _
		( byval h as any ptr, byval f as zstring ptr, byval l as uinteger ) as long
end extern

extern "c"
	declare sub crt_free alias "free" ( byval p as any ptr )
end extern

print "-- both entry points resolve"
print "  distinct="; ( cast( any ptr, @pParse ) <> cast( any ptr, @pTest ) )

'' Renders one parse. A NULL pointer is shown as <null> so that the
'' empty-string-not-NULL rule is visible rather than assumed.
function show( byval p as zstring ptr ) as string
	if( p = 0 ) then return "<null>"
	return "[" + *p + "]"
end function

'' pr IS INITIALISED TO NULL, AND THAT IS NOT TIDINESS. strptr() on an EMPTY
'' FreeBASIC string is NULL, and fb_DevLptParseProtocol returns FALSE for a NULL
'' input BEFORE it allocates -- so it never writes the out-parameter, and an
'' uninitialised local is then read and freed.
''
'' Written as `= any` this PASSED in Release, where the slot happened to hold
'' zero, and SEGFAULTED in Debug, where it did not. Both runtimes did the same
'' thing; the test was reading its own uninitialised memory.
sub tryParse( byref s as string, byval subst as long )
	dim as LptProto ptr pr = 0
	dim as long r = pParse( @pr, strptr( s ), len( s ), subst )
	print "  [";  s; "] subst="; subst; " -> "; r;
	if( pr <> 0 ) then
		print " port="; pr->iPort; " proto="; show( pr->proto ); _
		      " name="; show( pr->name_ ); " title="; show( pr->title_ ); _
		      " emu="; show( pr->emu )
		crt_free( pr )
	else
		print " (no block)"
	end if
end sub

'' ------------------------------------------------------------------ PRN:

'' "PRN:" IS PORT 1 EITHER WAY, and subst rewrites the string in place -- which
'' is why the allocation carries a spare byte.
print "-- PRN:"
tryParse( "PRN:", 0 )
tryParse( "PRN:", -1 )
tryParse( "prn:", -1 )
tryParse( "PRN", 0 )

'' ------------------------------------------------------------------ LPTx:

'' THE PORT IS READ BACKWARDS FROM THE COLON, so "LPT:" is 0 and "LPT12:" is 12.
print "-- LPTx:"
tryParse( "LPT:", 0 )
tryParse( "LPT1:", 0 )
tryParse( "LPT2:", 0 )
tryParse( "LPT12:", 0 )
tryParse( "lpt3:", 0 )
tryParse( "LPT0:", 0 )

'' Rejections: no LPT prefix, and no colon.
print "-- rejections"
tryParse( "COM1:", 0 )
tryParse( "LPT1", 0 )
tryParse( "", 0 )
tryParse( "X", 0 )

'' ------------------------------------------------------------- the options

'' A KEY WITHOUT AN '=' IS THE NAME, and the test is whether the next '=' comes
'' before or after the next ',' -- so the name stops at the comma.
print "-- name, EMU and TITLE"
tryParse( "LPT:myprinter", 0 )
tryParse( "LPT:myprinter,EMU=TTY", 0 )
tryParse( "LPT:EMU=TTY", 0 )
tryParse( "LPT:EMU=TTY,TITLE=my job", 0 )
tryParse( "LPT:myprinter,EMU=TTY,TITLE=my job", 0 )
tryParse( "LPT1:HP LaserJet,TITLE=report", 0 )

'' CASE-INSENSITIVE KEYS.
tryParse( "LPT:emu=tty", 0 )
tryParse( "LPT:Title=x", 0 )

'' SPACES AROUND '=' AND BEFORE ',' ARE STRIPPED, from both sides.
print "-- whitespace"
tryParse( "LPT:EMU = TTY", 0 )
tryParse( "LPT:EMU=TTY ,TITLE=x", 0 )
tryParse( "LPT: name , EMU = TTY ", 0 )
tryParse( "LPT:,,,", 0 )

'' AN UNKNOWN KEY IS IGNORED, deliberately -- fbc allows for forward
'' compatibility, so this must parse and simply drop the option.
print "-- unknown options are ignored"
tryParse( "LPT:p,FUTURE=x", 0 )
tryParse( "LPT:p,FUTURE=x,EMU=TTY", 0 )

'' A TRAILING '=' WITH NO VALUE, and a value with an embedded '='.
print "-- degenerate options"
tryParse( "LPT:EMU=", 0 )
tryParse( "LPT:EMU=a=b", 0 )
tryParse( "LPT:=x", 0 )

'' ------------------------------------------------------------------ TEST

'' The yes/no form. Same answers, no block left behind -- and subst is FALSE, so
'' "PRN:" is accepted without being rewritten.
print "-- fb_DevLptTestProtocol"
dim shared as zstring ptr tcases(0 to 7) = { _
	@"PRN:", @"LPT:", @"LPT1:", @"LPT:p,EMU=TTY", _
	@"COM1:", @"LPT1", @"", @"nonsense" }
for i as integer = 0 to 7
	print "  ["; *tcases(i); "] -> "; pTest( 0, tcases(i), len( *tcases(i) ) )
next

print "done"
