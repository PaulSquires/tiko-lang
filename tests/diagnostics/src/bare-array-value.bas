'' AN ARRAY NAME WITHOUT A SUBSCRIPT IS NOT A VALUE -- fbc error 73, "Array access, index
'' expected". Measured:
''
''     print a                 error 73        a( 0 to 3 )
''     draw a                  error 73
''     dim n as integer = a + 1                error 73
''     print a( 0 )            OK
''     print lbound( a )       OK
''     erase a                 OK
''
'' CHECKED AT THE SITES THAT CERTAINLY NEED A VALUE, and nowhere else. 'erase',
'' 'redim', 'lbound' and a BYDESC argument all take the bare name and are the ordinary
'' way to write one -- a blanket rule over every identifier would refuse them all.
''
'' A FIXED-LENGTH STRING IS NOT AN ARRAY HERE, though it is one in the type table:
'' 'zstring * N' and 'wstring * N' are arrays of a character builtin, and comparing two of
'' them is ordinary. Counting them refused six files fbc accepts.
dim shared as integer a( 0 to 3 )
dim shared as ubyte pix( 0 to 3 )
dim shared as zstring * 8 z1
dim shared as zstring * 8 z2

'' -- refused ------------------------------------------------------------------
sub refused( )
    print a
    draw pix
    dim n as integer = a + 1
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    print a( 0 )
    print lbound( a )
    erase a
    print cast( integer, z1 = z2 )
end sub
