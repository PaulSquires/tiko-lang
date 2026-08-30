'' AN RVALUE PASSED AS A 'zstring ptr' IS BORROWED INTO A TEMPORARY, and the temporary
'' is deleted. Measured, for a 'byval as const zstring ptr' parameter:
''
''     T( s )        -- a variable: the descriptor is taken as it is
''     T( "lit" )    -- a literal: the bytes are taken as they are
''     T( str( n ) ) -- fb_StrAssign( &TMP, -1, vr, -1, 0 )
''                      T( *(char**)&TMP ); fb_StrDelete( &TMP )
''     T( s & "x" )  -- the same borrow
''
'' tiko took the data pointer straight out of the RUNTIME's temporary and deleted
'' nothing, so every such argument leaked one string. The comment on that row already
'' SAID fbc copies it first; the row just never did it.
declare function T( byval k as const zstring ptr ) as long

sub go()
    dim as long n = 5
    dim as string s = "ab"
    dim as long r

    r = T( s )
    r = T( "lit" )
    r = T( str( n ) )
    r = T( s & "x" )
    print r
end sub
