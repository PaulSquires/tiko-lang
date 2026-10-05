type M1
    as long q
    declare operator cast( ) as double
end type
operator M1.cast( ) as double : print "[d]"; : return q + 0.25 : end operator
type S1
    as long q
    declare operator cast( ) as string
end type
operator S1.cast( ) as string : print "[s]"; : return "ab" : end operator
type Box
    as long n
    as string t
    declare property N2( byval v as long )
    declare property N2( ) as long
    declare property T2( byref v as string )
    declare property T2( ) as string
    declare sub Put( byval v as long )
    declare function Twice( byval v as double ) as double
end type
property Box.N2( byval v as long ) : n = v : end property
property Box.N2( ) as long : return n : end property
property Box.T2( byref v as string ) : t = v : end property
property Box.T2( ) as string : return t : end property
sub Box.Put( byval v as long ) : n = v + 100 : end sub
function Box.Twice( byval v as double ) as double : return v * 2 : end function
operator + ( byref b as Box, byval v as long ) as long : return b.n + v : end operator
dim as M1 m : m.q = 3
dim as S1 s
dim as Box b
b.N2 = m : print b.N2
b.T2 = s : print b.T2
b.Put( m ) : print b.n
print b.Twice( m )

with b
    .N2 = m : print .N2
end with
