type AF as A
type B2
    as long w
    declare constructor( )
    declare constructor( byref x as AF )
end type
type A
    as long v = 1
    declare operator cast( ) as B2
end type
constructor B2( ) : w = 0 : end constructor
constructor B2( byref x as A ) : w = 300 : end constructor
operator A.cast( ) as B2
    dim as B2 r
    r.w = 400
    return r
end operator
sub takeB( byval b as B2 ) : print "byval"; b.w : end sub
sub takeR( byref b as B2 ) : print "byref"; b.w : end sub
operator + ( byref l as B2, byval r as long ) as long : return l.w + r : end operator
dim as A aa
takeB( aa )
takeR( aa )
dim as B2 bv = aa
print "init"; bv.w
bv = aa
print "assign"; bv.w
print "cast"; cast( B2, aa ).w
function mk( byref x as A ) as B2
    return x
end function
print "return"; mk( aa ).w
type H
    as B2 f
end type
dim as H h
h.f = aa
print "field"; h.f.w
dim as B2 arr(1)
arr(0) = aa
print "elem"; arr(0).w
dim as B2 ptr pb = new B2( aa )
print "new"; pb->w
