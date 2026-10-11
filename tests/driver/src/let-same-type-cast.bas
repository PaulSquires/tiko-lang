'' See tests/driver/let-same-type-cast.test.
type Fx
    raw as longint
    declare operator let( byval v as double )
    declare operator cast( ) as double
end type
operator Fx.let( byval v as double ) : raw = cint( v * 1000 ) : end operator
operator Fx.cast( ) as double : return raw / 1000 : end operator
operator + ( byref a as Fx, byref b as Fx ) as Fx
    dim as Fx r
    r.raw = a.raw + b.raw
    return r
end operator

type Holder
    f as Fx
    declare sub Take( byref o as Fx )
end type
sub Holder.Take( byref o as Fx )
    this.f = o
end sub

dim as Fx p, q, s
p = 0.1 : q = 0.2
s = p + q
print "sum"; s.raw
s = p
print "copy"; s.raw
dim as Holder h
h.Take( q )
print "member"; h.f.raw
s = 1.25
print "let"; s.raw
