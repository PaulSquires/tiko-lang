'' 'close( n )' IN EXPRESSION POSITION, which yields the ERROR CODE. file/close.bas asks
'' it ten times, every one about a channel that is not open, and none of them lowered:
'' 'close' is a KEYWORD, so 'e = close( 0 )' parsed as an ordinary call to a name.
''
'' Measured, and both forms have a value:
''
''   e = close( 0 )    vr$1 = fb_FileClose( 0 )
''   e = close( )      vr$1 = fb_FileCloseAll( )
''
'' -- the same calls the STATEMENT form makes with their results discarded. So this is
'' the shape OPEN and GET already have here: a parser hook that reads ONE channel and
'' stops at the ')', building the SAME N_INTRINSIC node the statement form builds, so
'' lowering needs no second shape.
''
'' ONLY WITH A '(' IMMEDIATELY AFTER, which is what keeps 'close #1' as a statement.
'' And only ONE channel: 'close #1, #2' is two calls and has no single value to be --
'' fbc does not accept the comma form in an expression either.
dim as long e
dim as long f = freefile

e = close( 0 )
print e
e = close( 1 )
print e
e = close( )
print e

open "tests-close.tmp" for output as #f
e = close( f )
print e
kill "tests-close.tmp"
