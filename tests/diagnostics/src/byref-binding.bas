'' A BYREF BINDING NEEDS SOMETHING WITH AN ADDRESS, and it needs one at all. Measured:
''
''     dim byref i as integer = 1          error 24     a number has no address
''     var byref i = f( )                  error 24     nor does a call's RESULT
''     dim byref i as integer = g + 1      error 3      nor an arithmetic expression
''     dim byref i as integer              error 320    and it may not be left unbound
''     dim byref i as integer = g          OK
''     dim byref i as integer = g( 0 )     OK           an element has one
''     var byref i = "abc"                 OK           a LITERAL STRING has one
''     dim byref as long r = o.Value( )    OK           when Value returns BYREF
''
'' The last two rows are what the test turns on: a string literal lives in the data
'' segment, and a byref RESULT is already a reference -- binding one to it is the point.
'' (The string case is exercised by dim/byref-bad-init-2-var.bas and
'' warnings/pp-print-typeof.bas, which fbc accepts; written SHARED it is fbc error 11 for
'' an unrelated reason, so it is not repeated here.)
''
'' ONLY THE SHAPES THAT CERTAINLY HAVE NO ADDRESS are reported. An indexing expression
'' looks exactly like a call and is an lvalue, which is what the target's symbol kind
'' tells apart.
dim shared as integer g
dim shared as integer arr( 0 to 1 )

declare function byval_( ) as integer
declare function byref_( ) byref as integer

'' -- refused ------------------------------------------------------------------
dim shared byref bad1 as integer = 1
dim shared byref bad2 as integer = byval_( )

'' -- accepted -----------------------------------------------------------------
''
'' LOCAL, because a SHARED initialiser must be a CONSTANT -- 'dim shared byref ok3 as
'' integer = byref_( )' is fbc error 11 for that reason and not for this one.
sub accepted( )
    dim byref ok1 as integer = g
    dim byref ok2 as integer = arr( 0 )
    dim byref ok3 as integer = byref_( )
end sub
