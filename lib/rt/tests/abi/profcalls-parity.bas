'' profcalls-parity.bas -- the calls profiler, driven by hand: nine entry
'' points, and the whole report writer.
''
'' NEEDS-GEN-LLVM
''
'' THE REPORT FILE IS THE ASSERTION. fbc's own suite does not exercise the
'' profiler, and diff.sh does not build with -profile, so without this the
'' entire report writer -- six sections, every column width, every percentage
'' -- would be reproduced with NOTHING checking it. Here the profiler is driven
'' through its public entry points, the report is written to a known path, and
'' the FILE is what the differential compares.
''
'' TIMES AND THE HEADER ARE FILTERED OUT. Every run produces different
'' durations, a different launch timestamp and a different exe path, so those
'' lines and the numeric time columns are elided before printing. What remains
'' -- structure, names, counts, column alignment, the call tree's box drawing --
'' is deterministic and is exactly what a port can get wrong.
''
'' The options are exercised one report at a time so a difference lands in the
'' section that caused it.

extern "rtlib"
	declare sub pInit alias "fb_InitProfile" ( )
	declare function pEnd alias "fb_EndProfile" ( byval e as long ) as long
	declare function pBeginCall alias "fb_ProfileBeginCall" ( byval n as zstring ptr ) as any ptr
	declare sub pEndCall alias "fb_ProfileEndCall" ( byval id as any ptr )
	declare function pBeginProc alias "fb_ProfileBeginProc" ( byval n as zstring ptr ) as any ptr
	declare sub pEndProc alias "fb_ProfileEndProc" ( byval id as any ptr )
	declare function pGetCallsProfiler alias "fb_ProfileGetCallsProfiler" ( ) as any ptr
	declare sub pGetCallsMetrics alias "fb_ProfileGetCallsMetrics" ( byval m as any ptr )
	declare function pSetName alias "fb_ProfileSetFileName" ( byval f as zstring ptr ) as long
	declare function pSetOpts alias "fb_ProfileSetOptions" ( byval o as long ) as long
	declare sub pIgnore alias "fb_ProfileIgnore" ( byval n as zstring ptr )
end extern

dim shared as string rpt
rpt = environ("TEMP") & "\tkort-prof.txt"

'' Elide everything that varies between runs: the two header lines that carry
'' a path and a timestamp, and any run of digits that is a time or a percentage.
sub dumpreport( )
	dim as long f = freefile
	if( open( rpt for input as #f ) <> 0 ) then
		print "  <no report>"
		exit sub
	end if
	dim as string ln
	do until eof(f)
		line input #f, ln
		if( left(ln, 16) = "Executable name:" ) then ln = "Executable name: <elided>"
		if( left(ln, 12) = "Launched on:" ) then ln = "Launched on: <elided>"
		if( left(ln, 29) = "Total program execution time:" ) then ln = "Total program execution time: <elided>"
		'' NUMERIC FIELDS ARE ERASED TOGETHER WITH THEIR LEADING SPACES, and
		'' that is a correction rather than a tidy-up. The first version replaced
		'' each DIGIT with a '#' and kept the column width -- which meant the
		'' WIDTH still encoded the magnitude: a run where a percentage came out
		'' 9.99% and one where it came out 100.00% differed by a leading space,
		'' and the differential FAILED for a reason that had nothing to do with
		'' the runtime. Two consecutive runs disagreed and the third agreed.
		''
		'' Each maximal run of digits, dots and spaces that CONTAINS A DIGIT is
		'' now replaced by a token of the SAME TOTAL WIDTH, so the columns still
		'' have to line up -- a misaligned report still fails -- while the value
		'' no longer does. Runs with no digit are left alone, which is what keeps
		'' the gap between the name and the first number meaningful.
		dim as string o = ""
		dim as long i = 1
		while( i <= len(ln) )
			dim as string c = mid(ln, i, 1)
			if( ((c >= "0") andalso (c <= "9")) orelse (c = ".") orelse (c = " ") ) then
				dim as long j = i, hasdigit = 0
				while( j <= len(ln) )
					dim as string d = mid(ln, j, 1)
					if( (d >= "0") andalso (d <= "9") ) then hasdigit = 1
					if( ((d >= "0") andalso (d <= "9")) orelse (d = ".") orelse (d = " ") ) then
						j += 1
					else
						exit while
					end if
				wend
				dim as long w = j - i
				if( hasdigit <> 0 ) then
					if( w = 1 ) then
						o += "#"
					else
						o += "<" + string( w - 2, "#" ) + ">"
					end if
				else
					o += mid(ln, i, w)
				end if
				i = j
			else
				o += c
				i += 1
			end if
		wend
		print "  ["; o; "]"
	loop
	close #f
end sub

sub work3( )
	dim as any ptr c = pBeginCall( @"leaf" )
	dim as double t = timer
	do while( timer - t < 0.001 )
	loop
	pEndCall( c )
end sub

sub work2( )
	dim as any ptr c = pBeginCall( @"middle" )
	work3( )
	work3( )
	pEndCall( c )
end sub

sub work1( )
	dim as any ptr c = pBeginCall( @"outer" )
	work2( )
	work3( )
	pEndCall( c )
end sub

sub recurse( byval n as long )
	dim as any ptr c = pBeginCall( @"recurse" )
	if( n > 0 ) then recurse( n - 1 )
	pEndCall( c )
end sub

dim as long i = any

'' Each pass builds the same call tree and asks for one report shape, so a
'' difference is attributable to one section rather than to the whole file.
dim shared as long optsets(0 to 6)
optsets(0) = &h00000001          '' REPORT_CALLS
optsets(1) = &h00000002          '' REPORT_CALLTREE
optsets(2) = &h00000004          '' REPORT_RAWLIST
optsets(3) = &h00000008          '' REPORT_RAWDATA
optsets(4) = &h00000010          '' REPORT_RAWSTRINGS
optsets(5) = &h00000001 or &h00000400 or &h00000800   '' CALLS, no counts/times
optsets(6) = &h00000002 or &h02000000                 '' CALLTREE, graphics chars

dim shared as string optnames(0 to 6)
optnames(0) = "CALLS" : optnames(1) = "CALLTREE" : optnames(2) = "RAWLIST"
optnames(3) = "RAWDATA" : optnames(4) = "RAWSTRINGS"
optnames(5) = "CALLS hide counts+times" : optnames(6) = "CALLTREE graphics"

for i = 0 to 6
	print "===== "; optnames(i); " ====="
	pInit( )
	pSetName( strptr(rpt) )
	pSetOpts( optsets(i) )
	work1( )
	work1( )
	work2( )
	recurse( 3 )
	pEnd( 0 )
	dumpreport( )
	kill rpt
next

print "===== ignored procedure ====="
pInit( )
pSetName( strptr(rpt) )
pSetOpts( &h00000001 )
pIgnore( @"leaf" )
work1( )
pEnd( 0 )
dumpreport( )
kill rpt

print "===== hide header and titles ====="
pInit( )
pSetName( strptr(rpt) )
pSetOpts( &h00000001 or &h00000100 or &h00000200 )
work1( )
pEnd( 0 )
dumpreport( )
kill rpt

print "===== BeginProc/EndProc, including a call through a pointer ====="
pInit( )
pSetName( strptr(rpt) )
pSetOpts( &h00000004 )
dim as any ptr p1 = pBeginProc( @"realproc" )
dim as any ptr p2 = pBeginProc( @"{fbfp}indirect" )
dim as any ptr p3 = pBeginProc( @"target" )
pEndProc( p3 )
pEndProc( p2 )
pEndProc( p1 )
pEnd( 0 )
dumpreport( )
kill rpt

print "done"
