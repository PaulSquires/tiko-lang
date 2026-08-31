'' TWO RULES, both measured.
''
'' A FIXED-LENGTH STRING HAS NO PARAMETER FORM AT ALL -- fbc's error 324, "Fixed-length
'' string combined with BYREF (not supported)", and 59 for the byval spelling. The
'' surprise is the third row: writing NEITHER modifier is refused too, so this is not a
'' rule about byref.
''
''     sub f( z as zstring * 10 )          error 324
''     sub f( byref z as zstring * 10 )    error 324
''     sub f( byval z as zstring * 10 )    error 59
''     function f( ) as zstring * 10       error 324    a RESULT is the same refusal
''     dim byref z as zstring * 10 = "hi"  error 324    and so is a byref VARIABLE
''     sub f( byref z as zstring )         OK           no length, so not one
''     sub f( buf( ) as string )           OK           an ARRAY OF strings is not one
''
'' The last two rows are what the test turns on: 'string * N' is an array of TY_FIXSTR
'' and 'zstring * N' one of TY_ZSTRING, while an array of var-len strings is an array of
'' TY_STRING -- fb/sort.bi's SortMergeBy takes one.
''
'' AND '&=' CONCATENATES, so its target must be a string -- fbc error 20. 'i &= 1' over an
'' integer and 'd &= 1' over a double are both refused; 'i += 1' is another operator.

'' -- refused ------------------------------------------------------------------
declare sub takesFix( z as zstring * 10 )
declare sub takesFixByref( byref z as zstring * 10 )
declare sub takesFixByval( byval z as zstring * 10 )
declare function returnsFix( ) as zstring * 10

sub concatRefused( )
    dim as integer i
    dim as double d
    i &= 1
    d &= 1
end sub

'' -- accepted -----------------------------------------------------------------
declare sub takesZ( byref z as zstring )
declare sub takesArray( buf( ) as string )

sub concatAccepted( )
    dim as string s
    dim as integer i
    s &= "a"
    i += 1
end sub
