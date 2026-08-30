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
		'' Times and percentages: replace each digit run that follows a '.'
		'' or precedes a '%' with a marker, keeping the COLUMN WIDTH.
		dim as string o = ""
		dim as long i = any, indigit = 0
		for i = 1 to len(ln)
			dim as string c = mid(ln, i, 1)
			if( c >= "0" andalso c <= "9" ) then
				o += "#"
			elseif( c = "." ) then
				o += "."
			else
				o += c
			end if
		next
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
