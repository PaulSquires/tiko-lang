'' A '&' CHAIN WITH A WIDE TERM CHOOSES THE WSTRING OVERLOAD. Check types every '&' as
'' STRING -- lowering decides the width per term -- and overload resolution took that at
'' its word: 'MCase( wchr( &hE9 ) & "cole" )' called fb/string.bi's NARROW MCase, the
'' chain was narrowed to reach it, and the e-acute became '?'. Measured, fbc types
'' '"a" & wstr( 5 )' as WSTRING * 3 and calls the wide overload; a ustring term still
'' makes the chain a USTRING, and a narrow-only chain stays narrow.
''
'' fbc prints, one per line:
''      2    2    1    3
function Pick overload( byref s as const string ) as long
    return 1
end function
function Pick overload( byref s as const wstring ) as long
    return 2
end function
function Pick overload( byref s as const ustring ) as long
    return 3
end function

dim as ustring u = "u"
print Pick( wchr( &hE9 ) & "cole" )
print Pick( "a" & wstr( 5 ) )
print Pick( "a" & "b" & str( 1 ) )
print Pick( wchr( &hE9 ) & u )
