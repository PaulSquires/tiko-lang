'' A QUALIFIED STRING CONST, PASSED BYREF TO A USER PROCEDURE. See StrArgOwnDescriptor_.
namespace ns
    const P = "plain"
    namespace inner
        const Q = "deep"
    end namespace
end namespace
const LC = "plain"
type Rec
    as string v
    declare property Name( ) as string
end type
property Rec.Name( ) as string
    return v
end property
function Echo( byref s as string ) as string
    dim as string r = ""
    for i as long = 1 to len( s )
        r &= mid( s, i, 1 )
    next
    return r & " " & str( len( s ) )
end function
sub Twice( byref s as string )
    print "["; ucase( s ); "] ["; s; "]"
end sub
print "member "; Echo( ns.P )
print "nested "; Echo( ns.inner.Q )
print "bare "; Echo( LC )
using ns
print "using "; Echo( P )
Twice( ns.P )
dim as Rec o
o.v = "field"
print "property "; Echo( o.Name )
'' A FIELD is storage: it keeps passing its own descriptor, and a write reaches it.
sub Grow( byref s as string )
    s &= "+"
end sub
Grow( o.v )
print "written "; o.v
