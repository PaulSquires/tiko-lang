'' THE WIDTH STATEMENT -- three entry points, chosen by the FIRST argument.
''
'' Measured:
''
''   width 80, 25       fb_Width( 80, 25 )
''   width 80           fb_Width( 80, -1 )
''   width , 25         fb_Width( -1, 25 )
''   width "scrn:", 40  fb_WidthDev( fb_StrAllocTempDescZEx( "scrn:", 5 ), 40 )
''   width #1, 40       fb_WidthFile( 1, 40 )
''   n = width( )       fb_Width( -1, -1 )
''
'' -- AN OMITTED ARGUMENT IS -1, not a mask as COLOR's is and not a count: the two
'' statements sit next to each other in the runtime and do not share that rule.
''
'' The EXPRESSION form already lowered, through the builtin-call path that defaults
'' every argument it is not given. The STATEMENT had no case at all, so every spelling
'' of it declined with fb_WidthDev and fb_WidthFile sitting in the runtime table with
'' no caller -- which is how this was found: auditing the table for entries nothing
'' calls, the same way date( ) and time( ) turned up.
''
'' TWO FORMS ARE NOT HERE, both recorded rather than half-built:
''   'width #1, 40' -- IFORM_GENERIC cannot read a file number, so it is a PARSE error
''     before the lowering is asked, and fb_WidthFile still has no caller.
''   'n = width' with NO PARENTHESES -- a bare KEYWORD intrinsic in expression position
''     is a plain N_IDENT that nothing claims. 'n = width( )' is the same call and does
''     lower; 'n = pos' works only because pos is a PRELUDE function and not a keyword.
dim n as integer
dim c as integer = 80
dim r as integer = 25

width 80, 25
width 80
width , 25
width c, r
width "scrn:", 40

n = width( )
n = width( 80 )
print n
