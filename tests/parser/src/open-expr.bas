'' OPEN used as an EXPRESSION, which yields its error code. Measured against fbc: every
'' clause the statement form takes works inside the parens, including the comma-less QB
'' spelling, ACCESS, ENCODING and 'open pipe( ... )'.
''
'' The clause keywords are not expressions, so a generic call parse chokes on the first
'' one -- this needs the statement's own clause reader, stopped at the closing paren
'' rather than at end of line.

dim as long r
dim fn as string = "x.txt"

r = open( fn, for output, as #1 )
r = open( fn for input as #2 )
r = open( fn, for binary, access read, as #3 )
r = open( fn, for input, encoding "utf-8", as #4 )
r = open pipe( "dir", for input, as #5 )

'' The statement form is untouched.
open fn for output as #6
close #6
