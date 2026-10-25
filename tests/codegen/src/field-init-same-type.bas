'' A FIELD INITIALISED FROM A VALUE OF ITS OWN TYPE -- 'as P q = pp' -- had no path in lowering and
'' declined (TKO0994) for every UDT, a plain one of two integers included. fbc copies it: the bytes,
'' the implicit deep copy of a string field, or the copy constructor, and constructs it once.
'' Every line expected by tests/codegen/field-init-same-type-run.test is fbc-modern 1.20's.
type P
    as integer a, b
end type
type Q
    as string s
end type
type R
    as integer a
    declare constructor( )
    declare constructor( byref o as R )
end type
constructor R( )
    print "R()"
end constructor
constructor R( byref o as R )
    print "R copy"
    a = o.a
end constructor

dim shared as P pp = ( 3, 4 )
dim shared as Q qq
dim shared as R rr
qq.s = "hi"
rr.a = 9

function mp( ) as P
    dim as P t = ( 5, 6 )
    return t
end function

type W
    as P p1 = pp
    as P p2 = mp( )
    as Q q1 = qq
    as R r1 = rr
end type

print "--"
dim as W holder
qq.s = "changed"
print holder.p1.a; holder.p1.b; holder.p2.a; holder.p2.b
print holder.q1.s
print holder.r1.a
dim shared as W gw
print gw.q1.s; gw.r1.a
