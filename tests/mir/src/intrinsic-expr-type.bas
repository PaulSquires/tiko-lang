'' AN INTRINSIC IN EXPRESSION POSITION NEEDS A TYPE, and PRINT is what exposes it:
'' PRINT classifies each item by its type and declines the whole statement when it has
'' none. Every one of these lowered as 'dim as T x = ...', typed by its DESTINATION,
'' and declined as 'print ...'.
''
'' Measured with '#print typeof( ... )' on fbc:
''
''     close( 1 )                    LONG
''     open( "" for input as #1 )    LONG
''     get( #1, 1, d )               LONG
''     input( 3 )                    STRING
''     winput( 3 )                   WSTRING * 1
''     screen( 1, 2 )                ULONG      -- UNSIGNED, so fb_PrintUInt
''     atan2( f, f )                 SINGLE
''     atan2( d, d )                 DOUBLE
''
'' 'screen( row, col )' IS THE CONSOLE READ, a different construct from the SCREEN
'' STATEMENT, and its ARGUMENTS ARE SWAPPED on the way to the runtime: measured,
'' 'screen( 1, 2 )' is 'fb_ReadXY( 2, 1, 0 )'. FreeBASIC says (row, column) and
'' fb_ReadXY takes (x, y).
''
'' ATAN2 OVER TWO SINGLES IS A DIFFERENT FUNCTION, not the double widened: fbc emits
'' 'float vr = atan2f( F, F )'. Widening and narrowing back rounds twice.
dim as single f = 1.0
dim as double d = 1.0
dim as double buf

print close( 1 )
print open( "" for input as #1 )
print get( #1, 1, buf )
print input( 3 )
print winput( 3 )
print screen( 1, 2 )
print screen( 1, 2, 1 )
print atan2( f, f )
print atan2( d, d )
