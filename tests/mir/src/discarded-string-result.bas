'' A DISCARDED STRING RESULT IS RELEASED. Measured, for 'F()' as a statement over a
'' 'function F( ) as string':
''
''     FBSTRING* vr$0 = F( );
''     fb_hStrDelTemp( (FBSTRING*)vr$0 );
''
'' -- one leak per call without it, in a statement that lowered and verified. The
'' release used to run ONLY where LowerExpr could not produce a value, which is the
'' INTRINSIC case ('hex( i )' as a statement); a user function returning a string lowers
'' perfectly well and its result was dropped on the floor.
''
'' 'dim as string s = F()' is NOT this: the initialisation CONSUMES the temporary and
'' fbc emits no release for it.
function F( ) as string
    return "hi"
end function

sub go( )
    F( )
    dim as string s = F( )
    print s
    dim as long i = 255
    hex( i )
end sub

go( )
