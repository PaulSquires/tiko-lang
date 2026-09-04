'' intldrv-parity.bas -- the locale drivers. Seven entry points across six fbc
'' members on Windows, five on Linux.
''
'' NEEDS-GEN-LLVM
''
'' THE ANSWERS ARE THE MACHINE'S LOCALE AND ARE NOT PORTABLE, so nothing here
'' asserts a value against a constant. Both runtimes run on the same machine in
'' the same locale within seconds of each other, so what the differential
'' compares is that they give the SAME answer -- and what this file adds on top
'' is a set of STRUCTURAL properties that hold in every locale: a divider is one
'' or two characters, twelve month names are distinct, a format string contains
'' only the letters the translator can emit.
''
'' PRINTING THE NAMES RAW IS SAFE AND IS DONE. They are locale text, so on an
'' English machine they are "January" and on a French one "janvier" -- either
'' way both runtimes print the same bytes, and seeing them is what catches an
'' off-by-one in the weekday rotation that a "did something come back" check
'' cannot.
''
'' THE WEEKDAY ROTATION IS THE POINT OF THIS FILE. Windows' LOCALE_SDAYNAME1 is
'' MONDAY and POSIX's DAY_1 is SUNDAY, and the driver corrects for it on one
'' platform and not the other. Every name is printed with its index so a
'' one-position shift is visible; the check `index 1 differs from index 2` would
'' pass under a rotation and is therefore not what is relied on.
''
'' TWO OF THE SEVEN ARE WINDOWS-ONLY -- fb_hGetLocaleInfo and
'' fb_hIntlConvertString live in intl_core.o, which has no unix counterpart. They
'' are tested under a conditional and their absence on Linux is stated in the
'' output rather than silently skipped.
''
'' fb_hGetLocaleInfo's ALLOCATING MODE IS DRIVEN AND ITS RESULT IS FREED. It
'' mallocs and doubles from 128; a test that read the string and dropped it would
'' leak one block per call.
''
'' WHAT IS **NOT** COVERED: the Win95/NT<4 fallbacks inside both format drivers.
'' They run only when LOCALE_SSHORTDATE or LOCALE_STIMEFORMAT fails, which no
'' supported Windows does -- so those two branches are unreachable from here, in
'' both runtimes equally. They are named rather than left as a silent gap.

#include once "fbc-int/string.bi"

extern "c"
	declare function pGet     alias "fb_DrvIntlGet" ( byval idx as long ) as zstring ptr
	declare function pDateFmt alias "fb_DrvIntlGetDateFormat" _
		( byval b as zstring ptr, byval l as uinteger ) as long
	declare function pTimeFmt alias "fb_DrvIntlGetTimeFormat" _
		( byval b as zstring ptr, byval l as uinteger ) as long
	declare function pMonth   alias "fb_DrvIntlGetMonthName" _
		( byval m as long, byval s as long ) as any ptr
	declare function pWeekday alias "fb_DrvIntlGetWeekdayName" _
		( byval w as long, byval s as long ) as any ptr
	declare function pDelTemp alias "fb_hStrDelTemp" ( byval s as any ptr ) as long
end extern

#ifdef __FB_WIN32__
	extern "c"
		declare function pLocInfo alias "fb_hGetLocaleInfo" _
			( byval lcid as ulong, byval lct as ulong, byval b as zstring ptr, byval sz as uinteger ) as zstring ptr
		declare function pConv alias "fb_hIntlConvertString" _
			( byval s as any ptr, byval scp as long, byval dcp as long ) as any ptr
		declare sub crt_free alias "free" ( byval p as any ptr )
	end extern
#endif

print "-- the five portable drivers resolve"
dim shared as any ptr addrs( 0 to 4 )
addrs(0) = cast( any ptr, @pGet )
addrs(1) = cast( any ptr, @pDateFmt )
addrs(2) = cast( any ptr, @pTimeFmt )
addrs(3) = cast( any ptr, @pMonth )
addrs(4) = cast( any ptr, @pWeekday )
dim as long n = 0, distinct = 1
for i as integer = 0 to 4
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "  count="; n; " distinct="; distinct

#ifdef __FB_WIN32__
	print "  intl_core (win32 only) resolves="; _
	      ( (cast( any ptr, @pLocInfo ) <> 0) andalso (cast( any ptr, @pConv ) <> 0) )
#else
	print "  intl_core: WINDOWS ONLY, no unix counterpart -- not tested here"
#endif

'' ------------------------------------------------------------ the dividers

'' THE FIRST TWO ARE HARD-CODED ON POSIX AND ASKED OF THE LOCALE ON WINDOWS, so
'' a non-English Windows can report something other than "/" where Linux always
'' reports "/". Both runtimes see the same platform, so it compares -- and the
'' value is printed because that platform difference is worth seeing.
print "-- fb_DrvIntlGet"
sub showDiv( byval idx as long, byref label as string )
	dim as zstring ptr p = pGet( idx )
	if( p = 0 ) then
		print "  "; label; " <null>"
	else
		print "  "; label; " ["; *p; "] len="; len( *p )
	end if
end sub
showDiv( 0, "DateDivider  " )
showDiv( 1, "TimeDivider  " )
showDiv( 2, "DecimalPoint " )
showDiv( 3, "Thousands    " )
'' OUT OF RANGE IS NULL on both platforms -- the switch simply falls off.
showDiv( 4, "index 4      " )
showDiv( -1, "index -1     " )
showDiv( 99, "index 99     " )

'' A DIVIDER IS SHORT. Every locale's is one or two characters, and a driver that
'' returned an uninitialised buffer would fail this without ever printing
'' anything odd.
dim as long allshort = 1
for i as integer = 0 to 3
	dim as zstring ptr p = pGet( i )
	if( (p = 0) orelse (len( *p ) > 4) ) then allshort = 0
next
print "  all four are 1..4 characters="; allshort

'' THE STATIC BUFFER IS OVERWRITTEN BY THE NEXT CALL on Windows, which is why
'' fb_IntlGet copies. Two calls, second read first: on Windows both pointers are
'' the SAME address; on POSIX they are different literals.
dim as zstring ptr d0 = pGet( 0 )
dim as zstring ptr d1 = pGet( 1 )
print "  two calls share a buffer="; ( d0 = d1 ); " (true on Windows, false on POSIX)"

'' ------------------------------------------------------------ the formats

'' THE BOUNDARY IS THE POINT: a buffer one byte short must be REFUSED, and the
'' buffer is pre-filled so a partial write is visible in the output.
print "-- fb_DrvIntlGetDateFormat"
sub tryDate( byval l as uinteger )
	dim as zstring * 128 b = any
	for i as integer = 0 to 127
		b[i] = 42                        '' asterisk sentinel
	next
	b[127] = 0
	dim as long r = pDateFmt( @b, l )
	print "  len="; l; " -> "; r; " ["; b; "]"
end sub
tryDate( 128 )
tryDate( 64 )
tryDate( 11 )
tryDate( 10 )
tryDate( 4 )
tryDate( 1 )

print "-- fb_DrvIntlGetTimeFormat"
sub tryTime( byval l as uinteger )
	dim as zstring * 128 b = any
	for i as integer = 0 to 127
		b[i] = 42
	next
	b[127] = 0
	dim as long r = pTimeFmt( @b, l )
	print "  len="; l; " -> "; r; " ["; b; "]"
end sub
tryTime( 128 )
tryTime( 64 )
tryTime( 9 )
tryTime( 8 )
tryTime( 4 )
tryTime( 1 )

'' THE RESULT IS A VB PATTERN, NOT A strftime ONE -- which on POSIX means the
'' translator ran. A '%' surviving in the output would mean it did not, and that
'' is the single most likely way to get this wrong.
dim as zstring * 128 dfmt = any
dim as zstring * 128 tfmt = any
pDateFmt( @dfmt, 128 )
pTimeFmt( @tfmt, 128 )
print "  date format has no '%'="; ( instr( dfmt, "%" ) = 0 )
print "  time format has no '%'="; ( instr( tfmt, "%" ) = 0 )
print "  date format is non-empty="; ( len( dfmt ) > 0 )
print "  time format is non-empty="; ( len( tfmt ) > 0 )

'' ------------------------------------------------------------- the names

'' EVERY NAME IS PRINTED WITH ITS INDEX so a rotation is visible -- see the file
'' header on why a "they differ" check would not catch one.
print "-- fb_DrvIntlGetMonthName"
sub showMonth( byval m as long )
	dim as any ptr lg = pMonth( m, 0 )
	dim as any ptr sh = pMonth( m, -1 )
	dim as string a = "<null>", b = "<null>"
	if( lg <> 0 ) then a = *(*cptr( zstring ptr ptr, lg )) : pDelTemp( lg )
	if( sh <> 0 ) then b = *(*cptr( zstring ptr ptr, sh )) : pDelTemp( sh )
	print "  "; m; ": long=["; a; "] short=["; b; "]"
end sub
for m as integer = 0 to 13
	showMonth( m )
next

print "-- fb_DrvIntlGetWeekdayName"
sub showWeekday( byval w as long )
	dim as any ptr lg = pWeekday( w, 0 )
	dim as any ptr sh = pWeekday( w, -1 )
	dim as string a = "<null>", b = "<null>"
	if( lg <> 0 ) then a = *(*cptr( zstring ptr ptr, lg )) : pDelTemp( lg )
	if( sh <> 0 ) then b = *(*cptr( zstring ptr ptr, sh )) : pDelTemp( sh )
	print "  "; w; ": long=["; a; "] short=["; b; "]"
end sub
for w as integer = 0 to 8
	showWeekday( w )
next

'' TWELVE DISTINCT MONTHS AND SEVEN DISTINCT WEEKDAYS. A driver that returned the
'' same static buffer for every index -- an easy mistake, since the Windows one
'' does exactly that for the DIVIDERS -- would fail here and nowhere else.
dim shared as string mn(1 to 12), wn(1 to 7)
for m as integer = 1 to 12
	dim as any ptr r = pMonth( m, 0 )
	if( r <> 0 ) then mn(m) = *(*cptr( zstring ptr ptr, r )) : pDelTemp( r )
next
for w as integer = 1 to 7
	dim as any ptr r = pWeekday( w, 0 )
	if( r <> 0 ) then wn(w) = *(*cptr( zstring ptr ptr, r )) : pDelTemp( r )
next
dim as long mdist = 1, wdist = 1
for i as integer = 1 to 12
	for j as integer = 1 to i - 1
		if( mn(i) = mn(j) ) then mdist = 0
	next
next
for i as integer = 1 to 7
	for j as integer = 1 to i - 1
		if( wn(i) = wn(j) ) then wdist = 0
	next
next
print "  12 months distinct="; mdist
print "  7 weekdays distinct="; wdist

'' THE SHORT NAME IS NO LONGER THAN THE LONG ONE, in every locale.
dim as long shorter = 1
for m as integer = 1 to 12
	dim as any ptr r = pMonth( m, -1 )
	if( r <> 0 ) then
		if( len( *(*cptr( zstring ptr ptr, r )) ) > len( mn(m) ) ) then shorter = 0
		pDelTemp( r )
	end if
next
print "  every short month name fits inside the long one="; shorter

'' -------------------------------------------------------- intl_core, win32

#ifdef __FB_WIN32__

print "-- fb_hGetLocaleInfo, supplied buffer"
dim as zstring * 128 lbuf = any
for i as integer = 0 to 127
	lbuf[i] = 42
next
'' LOCALE_SDECIMAL, which every locale defines.
dim as zstring ptr lr = pLocInfo( &h0400, &h000E, @lbuf, 127 )
print "  returns the caller's buffer="; ( lr = @lbuf )
print "  value=["; lbuf; "]"

'' AN INVALID LCTYPE IS NULL and must not loop -- the growing mode retries only
'' on ERROR_INSUFFICIENT_BUFFER.
print "  invalid LCTYPE, supplied buffer -> null="; ( pLocInfo( &h0400, &hFFFF, @lbuf, 127 ) = 0 )

print "-- fb_hGetLocaleInfo, allocating (size 0)"
'' pszBuffer IS IGNORED IN THIS MODE, so a non-NULL one is passed deliberately to
'' prove it is discarded rather than written.
dim as zstring * 8 decoy = any
decoy[0] = 33 : decoy[1] = 0
dim as zstring ptr ar = pLocInfo( &h0400, &h000E, @decoy, 0 )
print "  allocated a new block="; ( (ar <> 0) andalso (ar <> @decoy) )
print "  decoy untouched="; ( decoy[0] = 33 )
if( ar <> 0 ) then
	print "  value=["; *ar; "]"
	crt_free( ar )
end if

'' AND AN INVALID LCTYPE IN ALLOCATING MODE must free and return NULL rather
'' than doubling until it exhausts memory.
print "  invalid LCTYPE, allocating -> null="; ( pLocInfo( &h0400, &hFFFF, 0, 0 ) = 0 )

'' A LONG ANSWER, to push the growing loop past its first 128 bytes. No LCTYPE
'' reliably exceeds that, so what is asserted is only that a long-ish one
'' (the full month name list is not available as one call) still succeeds.
dim as zstring ptr lr2 = pLocInfo( &h0400, &h0038, 0, 0 )     '' SMONTHNAME1
print "  SMONTHNAME1 allocating -> non-null="; ( lr2 <> 0 )
if( lr2 <> 0 ) then crt_free( lr2 )

#else
print "-- fb_hGetLocaleInfo / fb_hIntlConvertString: NOT PRESENT on this target"
#endif

print "done"
