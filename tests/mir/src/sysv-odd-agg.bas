'' Byval aggregates of 3, 5 and 13 bytes: on SysV each register's slot is as wide as
'' the register (ArgSlotSize_ in codegen/abi.bas), on the caller's copy and the callee's.
type S5 : a(0 to 4) as byte : end type
type S3 : a as byte : b as byte : c as byte : end type
type S13 : a(0 to 12) as byte : end type

function f5( byval b1 as byte, byval b2 as byte, byval b3 as byte, byval s as S5 ) as long
    return b1 * 100 + b2 * 10 + b3 + s.a(0) * 1000
end function

function f3( byval b1 as byte, byval s as S3 ) as long
    return b1 * 100 + s.a
end function

function f13( byval b1 as byte, byval b2 as byte, byval s as S13 ) as long
    return b1 * 100 + b2 * 10 + s.a(12)
end function

sub run_it( )
    dim junk(0 to 31) as ubyte
    for i as long = 0 to 31 : junk(i) = 255 : next
    dim s as S5
    s.a(0) = 7
    dim t as S3
    t.a = 5
    dim u as S13
    u.a(12) = 9
    print f5( 1, 2, 3, s ); "  expect 7123"
    print f3( 4, t ); "  expect 405"
    print f13( 1, 2, u ); "  expect 129"
end sub
run_it( )
