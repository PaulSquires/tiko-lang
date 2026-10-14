'' See tests/diagnostics/member-of-no-members.test.
type m as long
type U
    v as long
end type
enum E
    A = 4
end enum
type t2 as (int32, int64)
dim x as long

m.foo( )
x.foo( )
print x.foo
U.foo( )
print E.foo
t2.Pairs( )

dim t as t2
for each (d, f) in t
next
