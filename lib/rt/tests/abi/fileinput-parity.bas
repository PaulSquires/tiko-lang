'' fileinput-parity.bas -- INPUT #, LINE INPUT #, PRINT #, FLUSH, RESET and the
'' wide put-back. Fifteen entry points across ten fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THE TOKENISER IS THE POINT, and it is driven through INPUT # rather than
'' called directly: fb_FileInputNextToken reads from a TLS context that only
'' fb_FileInput fills in, and the pair is what a real INPUT # statement emits.
'' Calling the tokeniser without the context would read from a zeroed handle and
'' return empty strings on both runtimes -- another check that measures nothing.
''
'' EVERY FIELD IS PRINTED WITH ITS LENGTH IN BRACKETS. A tokeniser that drops a
'' delimiter reads every second field, and the values it does return are all
'' correct -- so the count and the lengths are what actually discriminate.

#include once "fbc-int/string.bi"

extern "c"
	declare function pPrintBuf   alias "fb_hFilePrintBuffer" _
		( byval fnum as long, byval b as zstring ptr ) as long
	declare function pPrintBufEx alias "fb_hFilePrintBufferEx" _
		( byval h as any ptr, byval b as any ptr, byval l as uinteger ) as long
	declare function pPrintBufW  alias "fb_hFilePrintBufferWstr" _
		( byval fnum as long, byval b as wstring ptr ) as long
	declare function pPrintBufWEx alias "fb_hFilePrintBufferWstrEx" _
		( byval h as any ptr, byval b as wstring ptr, byval l as uinteger ) as long
	declare function pPutBackWEx alias "fb_FilePutBackWstrEx" _
		( byval h as any ptr, byval s as wstring ptr, byval c as uinteger ) as long
	declare function pNextToken  alias "fb_FileInputNextToken" _
		( byval b as zstring ptr, byval m as integer, byval is_str as long, _
		  byval isfp as long ptr ) as integer
	declare sub      pNextTokenW alias "fb_FileInputNextTokenWstr" _
		( byval b as wstring ptr, byval m as integer, byval is_str as long )
	declare sub      pCtxDtor    alias "fb_INPUTCTX_Destructor" ( byval d as any ptr )
end extern

extern "rtlib"
	declare function pFlush      alias "fb_FileFlush" _
		( byval fnum as long, byval sb as long ) as long
	declare sub      pFlushAll   alias "fb_FileFlushAll" ( byval sb as long )
	declare sub      pFileReset      alias "fb_FileReset" ( )
	declare sub      pResetEx    alias "fb_FileResetEx" ( byval s as long )
	declare function pPutBackW   alias "fb_FilePutBackWstr" _
		( byval fnum as long, byval s as wstring ptr, byval c as uinteger ) as long
	declare function pInput      alias "fb_FileInput" ( byval fnum as long ) as long
	declare function pLineInput  alias "fb_FileLineInput" _
		( byval fnum as long, byval d as any ptr, byval dl as integer, byval fr as long ) as long
	declare function pLineInputW alias "fb_FileLineInputWstr" _
		( byval fnum as long, byval d as wstring ptr, byval m as integer ) as long
end extern

dim shared as any ptr addrs( 0 to 14 )
addrs(0)  = cast( any ptr, @pPrintBuf )
addrs(1)  = cast( any ptr, @pPrintBufEx )
addrs(2)  = cast( any ptr, @pPrintBufW )
addrs(3)  = cast( any ptr, @pPrintBufWEx )
addrs(4)  = cast( any ptr, @pPutBackWEx )
addrs(5)  = cast( any ptr, @pNextToken )
addrs(6)  = cast( any ptr, @pNextTokenW )
addrs(7)  = cast( any ptr, @pCtxDtor )
addrs(8)  = cast( any ptr, @pFlushAll )
addrs(9)  = cast( any ptr, @pFileReset )
addrs(10) = cast( any ptr, @pResetEx )
addrs(11) = cast( any ptr, @pPutBackW )
addrs(12) = cast( any ptr, @pInput )
addrs(13) = cast( any ptr, @pLineInput )
addrs(14) = cast( any ptr, @pLineInputW )

dim as long n = 0, distinct = 1
for i as integer = 0 to 14
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every entry point resolves"
print "  count="; n; " distinct="; distinct

const fname = "tkort-fileinput-parity.tmp"

'' ------------------------------------------------------------------ INPUT #

'' THE FULL GRAMMAR: bare fields, quoted fields, fields with embedded commas and
'' spaces, empty fields, and the three numeric forms whose exponent letter the
'' tokeniser rewrites.
print "-- INPUT # over the whole grammar"
kill fname
open fname for output as #1
print #1, "alpha,beta,gamma"
print #1, "  spaced  ,  fields  "
print #1, """quoted, with a comma"",plain"
print #1, ",,"
print #1, "trailing,"
close #1

dim as string a_, b_, c_
open fname for input as #1
input #1, a_, b_, c_
print "  1: ["; a_; "]"; len( a_ ); " ["; b_; "]"; len( b_ ); " ["; c_; "]"; len( c_ )
input #1, a_, b_
print "  2: ["; a_; "]"; len( a_ ); " ["; b_; "]"; len( b_ )
input #1, a_, b_
print "  3: ["; a_; "]"; len( a_ ); " ["; b_; "]"; len( b_ )
input #1, a_, b_, c_
print "  4: ["; a_; "]"; len( a_ ); " ["; b_; "]"; len( b_ ); " ["; c_; "]"; len( c_ )
input #1, a_, b_
print "  5: ["; a_; "]"; len( a_ ); " ["; b_; "]"; len( b_ )
close #1

'' THE d-TO-e REWRITE. `1D5` is QBASIC's double exponent; strtod accepts 'd'
'' only on Windows, so the tokeniser increments the character. `&hD` must NOT be
'' rewritten -- after an '&' a D is a hex digit.
print "-- numeric fields, including the d-to-e rewrite"
kill fname
open fname for output as #1
print #1, "1.5,1e3,1E3,1d3,1D3,-2.25"
print #1, "&h1D,&hFF,&o17,&b1011"
close #1

dim as double d1, d2, d3, d4, d5, d6
open fname for input as #1
input #1, d1, d2, d3, d4, d5, d6
print "  floats: "; d1; " "; d2; " "; d3; " "; d4; " "; d5; " "; d6
dim as longint h1, h2, h3, h4
input #1, h1, h2, h3, h4
print "  radix:  "; h1; " "; h2; " "; h3; " "; h4
close #1

'' ------------------------------------------------------------- LINE INPUT #

'' THE FAST PATH: a FILE* channel has pfnReadLine, so this goes straight to the
'' device. The empty line and the line with only spaces are the two that a
'' length-based check catches and a value-based one does not.
print "-- LINE INPUT #, the pfnReadLine path"
kill fname
open fname for output as #1
print #1, "first"
print #1, ""
print #1, "   "
print #1, "a line with, commas and ""quotes"" left intact"
print #1, string( 2000, "L" )
close #1

dim as string ln
dim as long k = 0
open fname for input as #1
while( not eof( 1 ) )
	line input #1, ln
	k += 1
	if( len( ln ) > 40 ) then
		print "  line"; k; " len="; len( ln ); " (long)"
	else
		print "  line"; k; " len="; len( ln ); " ["; ln; "]"
	end if
wend
close #1

'' A FIXED-LENGTH DESTINATION goes through a temporary and gets the fill-remainder
'' treatment, which is a different branch of the same function.
print "-- LINE INPUT # into a fixed-length string"
dim as string * 12 fx
open fname for input as #1
line input #1, fx
print "  ["; fx; "] len="; len( fx )
line input #1, fx
print "  ["; fx; "] len="; len( fx )
close #1

'' AND INTO A WSTRING, which has no VFS fallback: a device without
'' pfnReadLineWstr is error 1 rather than a slow path.
print "-- LINE INPUT # into a wstring"
dim as wstring * 32 wl
open fname for input as #1
line input #1, wl
print "  len="; len( wl ); " first="; asc( wl, 1 )
close #1

'' ------------------------------------------------------------------ PRINT #

'' fb_hFilePrintBuffer takes its length from strlen, so it cannot print an
'' embedded NUL; the *Ex form takes an explicit length and can. Both write to
'' the same channel, and the file size is what shows the difference.
'' THE Ex FORM IS ADDRESS-ONLY: it takes an FB_FILE*, and FreeBASIC source has
'' no way to obtain one for a channel -- fbc-int exposes a descriptor accessor
'' for ARRAYS but not for files. Passing 0 for it would silently write to the
'' SCREEN and the check would pass while measuring the console.
''
'' What IS testable is the contract that distinguishes the two: the fnum form
'' takes its length from strlen, so an embedded NUL TRUNCATES it. PRINT # writes
'' the same bytes whole. The two file sizes are the observable.
print "-- PRINT #: strlen truncates, PRINT # does not"
dim as zstring * 16 withnul
withnul = "ab"
withnul[2] = 0
withnul[3] = asc( "c" )
withnul[4] = 0

kill fname
open fname for output as #1
pPrintBuf( 1, @withnul )
close #1
open fname for binary as #1
print "  via fb_hFilePrintBuffer (strlen) ="; lof( 1 ); " bytes"
close #1

kill fname
dim as string four = chr( asc("a") ) + chr( asc("b") ) + chr( 0 ) + chr( asc("c") )
open fname for output as #1
print #1, four;
close #1
open fname for binary as #1
print "  via PRINT # (explicit length)    ="; lof( 1 ); " bytes"
close #1

'' ------------------------------------------------------------------ FLUSH

'' FLUSH -1 IS "ALL", not the printer handle -- the one place in this runtime
'' where -1 does not mean FB_HANDLE_PRINTER.
print "-- FLUSH"
kill fname
'' THERE IS NO `FLUSH` STATEMENT in FreeBASIC, so every check here goes through
'' the entry point -- which also means the RETURN value is read rather than ERR,
'' and this file avoids the trap the OPEN and REDIM tests both fell into.
open fname for output as #1
print #1, "buffered";
print "  flush #1        -> "; pFlush( 1, 0 )
print "  flush #1 + sync -> "; pFlush( 1, -1 )
print "  flush -1 (all)  -> "; pFlush( -1, 0 )
close #1

'' FLUSH ON AN INPUT CHANNEL IS ERROR 1 through the per-handle form, and SILENTLY
'' SKIPPED by the all-channels one -- because the loop tests for a pfnFlush and
'' an INPUT channel simply has one that reports nothing to do.
open fname for input as #1
print "  flush on an INPUT channel -> "; pFlush( 1, 0 )
pFlushAll( 0 )
print "  FlushAll over it: err="; err
close #1

'' AND ON A CLOSED CHANNEL, and on an out-of-range number.
print "  flush on a closed channel -> "; pFlush( 1, 0 )
print "  flush #999                -> "; pFlush( 999, 0 )

'' ------------------------------------------------------- the wide put-back

'' FOUR BYTES OF BUFFER, AND A WCHAR IS TWO OR FOUR. On Windows two wide
'' characters fit and a third is error 3; on Linux ONE fits and a second is
'' error 3. That is reported rather than hidden, because it is real.
print "-- the wide put-back buffer"
print "  sizeof(wstring)="; sizeof( wstring )
kill fname
open fname for output as #1
print #1, "0123456789"
close #1

dim as wstring * 4 pb
pb = wstr( "Z" )

'' ON AN ASCII CHANNEL the wide put-back is NARROWED to one byte per character,
'' so four fit on every target and the FIFTH is error 3 -- the wchar width does
'' not enter into it at all.
open fname for input as #1
dim as string acc = ""
for i as integer = 1 to 5
	acc += str( pPutBackW( 1, @pb, 1 ) ) + " "
next
print "  ASCII channel, five put-backs -> "; acc
close #1

'' ON AN ENCODED CHANNEL the characters are stored WHOLE, so the same four bytes
'' hold two on Windows and ONE on Linux. This is the wchar-width asymmetry, and
'' it is reported rather than hidden.
kill fname
open fname for output encoding "utf8" as #1
print #1, "0123456789"
close #1
open fname for input encoding "utf8" as #1
acc = ""
for i as integer = 1 to 3
	acc += str( pPutBackW( 1, @pb, 1 ) ) + " "
next
print "  UTF-8 channel, three put-backs -> "; acc
close #1
kill fname
open fname for output as #1
print #1, "0123456789"
close #1

'' AND ON A CLOSED CHANNEL it is error 1, tested before the buffer is touched.
print "  put-back on a closed channel -> "; pPutBackW( 1, @pb, 1 )

'' ------------------------------------------------------------------ RESET

'' RESET CLOSES EVERY OPEN CHANNEL and zeroes the table, so a channel number is
'' free again afterwards -- and calling it twice is a no-op, because the flag it
'' tests is cleared on the first pass.
print "-- RESET"
kill fname
open fname for output as #1
print #1, "x"
open fname + "2" for output as #2
print "  two channels open, err="; err
reset
print "  after reset, err="; err
print "  #1 reusable -> "; open( fname for output as #1 )
close #1
reset
print "  reset twice, err="; err
kill fname
kill fname + "2"

'' fb_FileResetEx: 0 is stdin, 1 is stdout, anything else is error 1. The two
'' valid ones are NOT called -- resetting this program's stdout would detach the
'' differential's own capture.
print "  ResetEx(2) -- an invalid stream number"
pResetEx( 2 )
print "    err="; err

print "done"
