'' NAMED TUPLE ELEMENTS -- a tiko extension; see symbols/tuplenames.bas. Every line
'' is also written positionally, which is what fbc accepts, and both must agree.
type Pt as (x as long, y as long)
type Rect as (tl as Pt, br as Pt)

type Holder
    as (a as long, b as string) pos
end type

function GetRect( ) as (tl as (x as long, y as long), br as (x as long, y as long))
    return ((100, 200), (300, 400))
end function

function MinMax( byval p as long, byval q as long ) as (lo as long, hi as long)
    if p < q then return (p, q)
    return (q, p)
end function

sub Bump( byref v as (lo as long, hi as long) )
    v.lo -= 1
    v.hi += 1
end sub

'' var: the names are the function result's
var r = GetRect( )
print "var " & r.tl.x & " " & r.tl.y & " " & r.br.x & " " & r.br.y
print "pos " & r._1._1 & " " & r._1._2 & " " & r._2._1 & " " & r._2._2

'' a call's result, directly
print "call " & GetRect( ).br.y & " " & MinMax( 9, 3 ).lo

'' a typedef, and a write through a name
dim as Rect rr = ((1, 2), (3, 4))
rr.tl.x = 5
rr.br = (7, 8)
print "typedef " & rr.tl.x & " " & rr.tl.y & " " & rr.br.x & " " & rr._2.y

'' assignment keeps the TARGET's names: the type is one type
dim as (left_ as Pt, right_ as Pt) other = rr
print "other " & other.left_.x & " " & other.right_.y

'' a pointer, through the typedef
dim as Pt ptr pp = @rr.tl
pp->y = 6
print "ptr " & pp->x & " " & (*pp).y

'' a byref parameter
dim as (lo as long, hi as long) m = MinMax( 4, 2 )
Bump( m )
print "byref " & m.lo & " " & m.hi

'' a UDT field
dim as Holder h
h.pos.a = 42
h.pos.b = "str"
print "field " & h.pos.a & " " & h.pos.b & " " & h.pos._2

'' an array element
dim as Pt arr( 0 to 2 )
arr( 1 ).x = 11
arr( 1 ).y = 12
print "array " & arr( 1 ).x & " " & arr( 1 )._2

'' WITH
with rr
    print "with " & .tl.x & " " & .br.x
end with

'' a name spelled like a position: '_1' is always the FIRST element
dim as (_2 as long, _1 as long) sw = (1, 2)
print "positional " & sw._1 & " " & sw._2
