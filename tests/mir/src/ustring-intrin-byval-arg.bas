'' A string intrinsic over a ustring, passed to 'byval as ustring' (tracks-2026 TB-008).
sub TakeU( byval s as ustring )
    print len( s )
end sub
dim as ustring u = "abc"
TakeU( ucase( u ) )
TakeU( lcase( u ) )
TakeU( trim( u ) )
TakeU( ltrim( u ) )
TakeU( rtrim( u ) )
TakeU( mid( u, 2 ) )
TakeU( mid( u, 2, 1 ) )
TakeU( left( u, 2 ) )
TakeU( right( u, 2 ) )
TakeU( ucase( u & "x" ) )
TakeU( left( u & "x", 2 ) )
