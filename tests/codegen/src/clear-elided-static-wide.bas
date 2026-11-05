'' See tests/codegen/clear-elided-static-wide-run.test.
dim as longint a = -1
clear a, , 4
print a
clear ( a, , 8 )
print a

sub g( )
    static as wstring * 8 w = wchr( &h2581 ) & wchr( &h41 )
    static as wstring * 4 t = wchr( &h1F600 ) & "ab"
    static as integer n = len( chr( 65 ) )
    static as integer m = len( chr( 65, 66 ) )
    print len( w ); asc( w ); asc( w, 2 ); n; m; len( t ); asc( t ); asc( t, 2 )
end sub
g( )

const L = len( chr( 65, 66 ) )
dim as string * len( chr( 1, 2, 3 ) ) f
print L; sizeof( f )
