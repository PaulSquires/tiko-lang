' A narrow 'space' or 'string' result for a 'wstring ptr' parameter is widened.
sub Show (byval p as wstring ptr)
    print len( *p ) & " " & asc( *p, 1 ) & " " & asc( *p, len( *p ) )
end sub

Show( string( 5, "x" ) )
Show( string( 4, 65 ) )
Show( space( 3 ) )
Show( "lit" )
dim s as string = string( 2, "y" )
Show( s )
Show( wstring( 2, wstr( "w" ) ) )
