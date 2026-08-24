'' STRING TEMPORARIES AS ARGUMENTS: an rvalue has no descriptor and no address, and
'' each of the three parameter shapes wants something different out of one.
sub takeByvalString( byval s as string, byval f as integer )
    print s, f
end sub

sub takeZstringPtr( byval p as zstring ptr, byval f as integer )
    print *p, f
end sub

sub takeWstringPtr( byval p as wstring ptr, byval f as integer )
    print *p, f
end sub

dim as wstring * 8 w
w = wstr( "ab" )

takeByvalString( hex( 255 ), 0 )
takeByvalString( whex( 255 ), 0 )
takeZstringPtr( hex( 255 ), 0 )
takeZstringPtr( w, 0 )
takeWstringPtr( whex( 255 ), 0 )
