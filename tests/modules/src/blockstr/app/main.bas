#import "acme/doc"
function Show( byref s as string ) as string
    dim as string r = ""
    for i as long = 1 to len( s )
        if asc( s, i ) = 10 then r &= "|" else r &= mid( s, i, 1 )
    next
    return r & " " & str( len( s ) )
end function
print Show( doc.USAGE )
dim as doc.Tag( of long ) t
t.v = 7
print Show( t.Render( ) )
