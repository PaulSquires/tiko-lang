'' AN ENUM CONSTANT PASSED BYREF is a temporary holding its value, as a const's is.
'' tiko gave it a frame slot named after the constant, never stored to, so the callee
'' read 0 or stack garbage. Output measured with fbc-modern 1.20 (2026-10-11).

enum E
    E_A = 5
    E_B
end enum

enum K explicit
    K_X = 40
    K_Y
end enum

sub PU( byref v as ulong ) : print "ulong:"; v : end sub
sub PL( byref v as long ) : print "long:"; v : end sub
sub PI( byref v as integer ) : print "integer:"; v : end sub
sub PE( byref v as E ) : print "enum:"; v : end sub
sub PB( byref v as byte ) : print "byte:"; v : end sub
sub PD( byref v as double ) : print "double:"; v : end sub

'' The callee may write through the reference; the constant must not change.
sub Bump( byref v as long ) : v += 100 : print "bumped:"; v : end sub

'' A generic byref parameter -- containers.Array( of T ).Push's shape.
type Box
    as ulong items( 0 to 3 )
    as long n
    declare sub Push( byref v as ulong )
end type
sub Box.Push( byref v as ulong )
    items( n ) = v : n += 1
end sub

PU( E_B )
PL( E_B )
PI( E_B )
PE( E_B )
PB( E_A )
PD( E_B )
PL( E.E_B )
PL( K.K_Y )
Bump( E_A )
print "after:"; E_A

dim as Box bx
bx.Push( E_A )
bx.Push( E_B )
print "box:"; bx.items( 0 ); bx.items( 1 ); bx.n
