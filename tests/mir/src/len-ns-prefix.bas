'' LEN / SIZEOF / TYPEOF drop a namespace prefix from a LEADING procedure name: fbc parses
'' what follows 'NS.' unqualified. See symbols/resolveintr.bas, DropNsPrefix_.

function Twice( byref s as string ) as string
    return s
end function
function Nw( ) as short
    return 1
end function

namespace NS
    function Twice( byref s as string ) as string
        return s & s
    end function
    function Nw( ) as longint
        return 7
    end function
    function Keep( byref s as string ) as string
        return s & s
    end function
    '' Inside NS the bare name is NS's own: 8.
    sub Inner( )
        print sizeof( NS.Nw( ) )
    end sub
end namespace

dim as string t = "ab"

'' Dropped: the global Twice is called and the global Nw measured (2).
print len( NS.Twice( t ) )
print sizeof( NS.Nw( ) )
dim as typeof( NS.Nw( ) ) q
print sizeof( q )
'' Kept: the prefix is not the first token.
print len( "x" & NS.Keep( t ) )
print len( ( NS.Keep( t ) ) )
NS.Inner( )
