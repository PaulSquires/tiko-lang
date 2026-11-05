'' See tests/diagnostics/value-with-args.test.
const X = 5
enum E
    K
end enum
type T
    f as long
end type
dim v as long
dim a( 3 ) as long
dim t1 as T
sub s( byval p as long )
end sub
dim pf as sub( byval as long ) = @s

true, 1
false 1
X 1
K, 1
v, 1
a( 1 ), 2
t1.f, 1
pf 1
"a" 1
"a"
print 1: 1
print 1: 2.5

'' all legal: a procedure called without parentheses
s 1
pf( 2 )
