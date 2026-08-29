'' 'input( n [, [#]f] )' AND 'winput( ... )' IN EXPRESSION POSITION -- n characters read
'' as a VALUE. A different construct from the INPUT STATEMENT, which reads variables, and
'' only the statement form existed: the expression form was 'expected an expression' at
'' the '#' and the whole enclosing statement declined. RTL_FILE_STR_INPUT and
'' RTL_FILE_WSTR_INPUT had been declared with no emit site at all.
''
'' Measured:
''
''     input( 2, #1 )   fb_FileStrInput ( 2ll, 1 )
''     input( 2 )       fb_FileStrInput ( 2ll, 0 )   -- no channel is 0
''     winput( 2, #1 )  fb_FileWstrInput( 2ll, 1 )
''
'' and run over a file holding 'aabbcc', they read 'aa' then 'b b '.
dim as string fn = "input-expression.tmp"
open fn for output as #1
print #1, "aabbcc"
close #1

open fn for input as #1
dim as string d = input( 2, #1 )
print "["; d; "]"
d = input( 2, #1 )
print "["; d; "]"
close #1

'' The WIDE half, as an assignment and as a comparison operand -- the second is what
'' file/input.bas writes, and it needs the intrinsic to be a WIDE OPERAND as well as a
'' value.
open fn for input as #1
dim as wstring * 8 w
w = winput( 2, #1 )
print "["; w; "]"
print ( winput( 2, #1 ) = wstr( "bb" ) )
close #1
kill fn
