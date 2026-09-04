'' dtparse-parity.bas -- fb_hDateParse and fb_hTimeParse. Two entry points across
'' two fbc members, and the grammar behind DATEVALUE, TIMEVALUE and ISDATE.
''
'' NEEDS-GEN-LLVM
''
'' THE PARSERS ARE CALLED DIRECTLY, not through DATEVALUE, because they return
'' FOUR things: a boolean, the three fields, and the LENGTH CONSUMED. Only the
'' first two reach DATEVALUE, and the length is what a combined date-and-time
'' string depends on -- fb_DateTimeParse hands the tail to the time parser at
'' exactly the offset the date parser stopped at.
''
'' THE DATE ORDER COMES FROM THE LOCALE, so `1/2/2000` means different things on
'' different machines. Both runtimes run on THIS machine, so they agree -- but
'' the test prints the parsed fields rather than a serial, which is what makes
'' the comparison meaningful rather than merely equal.

#include once "fbc-int/string.bi"

extern "c"
	declare function pDateParse alias "fb_hDateParse" _
		( byval t as zstring ptr, byval tl as uinteger, _
		  byval pd as long ptr, byval pm as long ptr, byval py as long ptr, _
		  byval pl as uinteger ptr ) as long
	declare function pTimeParse alias "fb_hTimeParse" _
		( byval t as zstring ptr, byval tl as uinteger, _
		  byval ph as long ptr, byval pmi as long ptr, byval ps as long ptr, _
		  byval pl as uinteger ptr ) as long
end extern

dim shared as any ptr addrs( 0 to 1 )
addrs(0) = cast( any ptr, @pDateParse )
addrs(1) = cast( any ptr, @pTimeParse )
print "-- both parsers resolve"
print "  count="; iif( addrs(0) <> 0, 1, 0 ) + iif( addrs(1) <> 0, 1, 0 ); _
      " distinct="; iif( addrs(0) <> addrs(1), 1, 0 )

'' ------------------------------------------------------------------ times

'' EVERY FIELD IS PRINTED, INCLUDING THE LENGTH CONSUMED -- a parser that gets
'' the right hour from the wrong number of characters is wrong, and only the
'' length says so.
'' THE TEXT IS COPIED INTO A FIXED BUFFER FIRST, because strptr on an EMPTY
'' FreeBASIC string is NULL -- and both parsers dereference their argument
'' before looking at the length. Passing it segfaulted BOTH runtimes
'' identically, so the differential reported "0 differing" for a run that had
'' stopped two thirds of the way through.
sub tryTime( byref s as string )
	dim as long h = -99, m = -99, sec = -99
	dim as uinteger l = &hFFFFFFFF
	dim as zstring * 64 buf = any
	buf = s
	dim as long r = pTimeParse( @buf, len( s ), @h, @m, @sec, @l )
	if( r = 0 ) then
		'' NOTHING IS WRITTEN ON FAILURE, so the sentinels must survive -- which
		'' is itself part of the contract and is printed rather than assumed.
		print "  ["; s; "] -> FALSE  (h="; h; " m="; m; " s="; sec; " len untouched="; ( l = &hFFFFFFFF ); ")"
	else
		print "  ["; s; "] -> TRUE   h="; h; " m="; m; " s="; sec; " used="; l
	end if
end sub

print "-- fb_hTimeParse"
dim shared as zstring ptr tcases(0 to 29) = { _
	@"0:0:0", @"00:00:00", @"12:00:00", @"23:59:59", @"1:2:3", _
	@"12:00", @"0:30", @"23:59", _
	@"24:00:00", @"12:60:00", @"12:00:60", @"-1:00", _
	@"12", @"1 am", @"1 AM", @"1am", @"1a", @"1 p", @"12 am", @"12 pm", _
	@"11 pm", @"13 pm", @"0 am", @"1:30 pm", @"12:30 am", _
	@"1 apple", @"1 x", @"", @"  3:04:05  ", @"3:4:5 trailing" }
for i as integer = 0 to 29
	tryTime( *tcases(i) )
next

'' ------------------------------------------------------------------ dates

sub tryDate( byref s as string )
	dim as long d = -99, m = -99, y = -99
	dim as uinteger l = &hFFFFFFFF
	dim as zstring * 64 buf = any
	buf = s
	dim as long r = pDateParse( @buf, len( s ), @d, @m, @y, @l )
	if( r = 0 ) then
		print "  ["; s; "] -> FALSE  (len untouched="; ( l = &hFFFFFFFF ); ")"
	else
		print "  ["; s; "] -> TRUE   d="; d; " m="; m; " y="; y; " used="; l
	end if
end sub

print "-- fb_hDateParse, the short forms"

'' THE FIELD ORDER COMES FROM THE LOCALE, and the first version of this table
'' was entirely m/d/y -- so all eighteen cases returned FALSE and the section
'' measured one branch while looking exhaustive. On a machine whose short date
'' format is ISO, the FIRST number is the year, and `1/2/2000` is rejected
'' because the permutation makes the day 2000.
''
'' Both orders are listed, so whichever the machine uses, one group parses and
'' the other is rejected -- and the OUTPUT SAYS WHICH, rather than the table
'' silently agreeing on failure.
dim shared as zstring ptr dshort(0 to 25) = { _
	@"2000/1/2", @"2000-1-2", @"2000.1.2", @"2000/01/02", _
	@"1999/12/31", @"2000/2/29", @"2001/2/29", _
	@"2000/13/1", @"2000/1/32", @"2000/0/1", @"2000/1/0", _
	@"1/2/2000", @"01/02/2000", @"1-2-2000", @"1.2.2000", _
	@"2000/1-2", @"2000-1/2", @"2000.1-2", _
	@"00/1/2", @"1999/1/2", @"12345/1/2", _
	@"2000/1", @"2000/1/", @"2/29/2000", @"2/29/2001", @"1/2" }
for i as integer = 0 to 25
	tryDate( *dshort(i) )
next

print "-- fb_hDateParse, the named-month forms"
'' FULL AND ABBREVIATED, MONTH FIRST AND DAY FIRST. The comma is REQUIRED when
'' the month leads and OPTIONAL when the day does -- an asymmetry that only a
'' table like this shows.
dim shared as zstring ptr dnamed(0 to 17) = { _
	@"Jan 1, 2000", @"January 1, 2000", @"Jan. 1, 2000", _
	@"Jan 1 2000", @"January 1 2000", _
	@"1 Jan 2000", @"1 January 2000", @"1 Jan, 2000", _
	@"1. Jan 2000", @"1. January 2000", _
	@"Dec 31, 1999", @"December 31, 1999", _
	@"Feb 29, 2000", @"Feb 29, 2001", _
	@"Marching 1, 2000", @"Mar 1, 2000", _
	@"NotAMonth 1, 2000", @"Jan 1, 00" }
for i as integer = 0 to 17
	tryDate( *dnamed(i) )
next

print "-- fb_hDateParse, whitespace and rubbish"
dim shared as zstring ptr dodd(0 to 9) = { _
	@"  1/2/2000", @"1 / 2 / 2000", @"1/2/2000 trailing", _
	@"", @"   ", @"not a date", @"//", @"1", @"1/", @"x/y/z" }
for i as integer = 0 to 9
	tryDate( *dodd(i) )
next

'' ------------------------------------------------------- the NULL out-params

'' EVERY OUT-PARAMETER IS OPTIONAL. Passing NULL for all four must still return
'' the right boolean and must not fault -- which is how fb_IsDate calls it.
print "-- NULL out-parameters"
dim as zstring * 32 ok1 = "2000/1/2"
dim as zstring * 32 bad1 = "rubbish"
print "  date, all NULL, valid   -> "; pDateParse( @ok1, len( ok1 ), 0, 0, 0, 0 )
print "  date, all NULL, invalid -> "; pDateParse( @bad1, len( bad1 ), 0, 0, 0, 0 )
dim as zstring * 32 ok2 = "12:34:56"
print "  time, all NULL, valid   -> "; pTimeParse( @ok2, len( ok2 ), 0, 0, 0, 0 )
print "  time, all NULL, invalid -> "; pTimeParse( @bad1, len( bad1 ), 0, 0, 0, 0 )

'' ---------------------------------------------------------- the length, used

'' THE LENGTH IS WHAT MAKES A COMBINED STRING WORK. `1/2/2000 12:34` is parsed
'' by handing the tail to the time parser at the offset the date parser stopped
'' at, so the two lengths must add up to the whole string.
print "-- date then time, at the offset the date parser reported"
dim as zstring * 64 both_ = "2000/1/2 12:34:56"
dim as long bd = 0, bm = 0, by = 0
dim as uinteger bl = 0
dim as long r1 = pDateParse( @both_, len( both_ ), @bd, @bm, @by, @bl )
print "  date part -> "; r1; " d="; bd; " m="; bm; " y="; by; " used="; bl
if( r1 <> 0 ) then
	dim as zstring * 64 tail_ = any
	tail_ = mid( both_, bl + 1 )
	dim as long th = 0, tm = 0, ts = 0
	dim as uinteger tl = 0
	dim as long r2 = pTimeParse( @tail_, len( tail_ ), @th, @tm, @ts, @tl )
	print "  time part -> "; r2; " h="; th; " m="; tm; " s="; ts; " used="; tl
	print "  lengths add up to the whole string="; ( bl + tl = len( both_ ) )
end if

print "done"
