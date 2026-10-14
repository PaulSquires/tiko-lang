'' See tests/diagnostics/type-name-value.test.
type m as long
type U
    v as long
    const K = 3
end type
enum E
    A = 4
end enum
dim x as long

m = 5
m += 1
print m
dim y as long = m
x = m + 1
U = 5
E = 1

'' all legal: a type name where a type is meant
print sizeof( m ), len( m ), U.K, E.A
dim z as m = cast( m, 2.7 )
