'' A STATIC or SHARED float initialiser folds a NAMED constant and ATN. See
'' tests/mir/static-float-const-init.test.

type F3
    as single x, y, z
end type

const k = 3

'' ATN, measured bit for bit against fbc-modern's own folding.
dim shared as double a( 0 to 19 ) = { atn( 1 ), atn( -1 ), atn( 0.5 ), atn( 2 ), atn( 0.1 ), _
    atn( 10 ), atn( 100 ), atn( 1e-8 ), atn( 1e8 ), atn( 3 ), atn( 0.25 ), atn( 0.75 ), _
    atn( 1.5 ), atn( -0.3 ), atn( 1e300 ), atn( 0.999 ), atn( 1.001 ), atn( k ), _
    4 * atn( 1 ), atn( 1 / 3 ) }
dim shared as single b( 0 to 5 ) = { atn( 1 ), 4 * atn( 1 ) / 2, atn( 0.1f ), atn( 7 ), atn( -2.5f ), atn( k ) }

'' starshine.bas's PLANET: a static UDT from a const declared in the procedure's body.
sub planet( )
    const pi2 = 4 * atn( 1 )
    static as F3 ang = type( 0, .2, pi2 / 2 )
    ang.x += .01
    print ang.x, ang.y, ang.z
end sub

'' A scalar static from a named const: this one did not even decline -- the integer
'' folder answered, into a slot a float global never reads, and it printed 0.
sub scalar( )
    const kk = 3
    static as single z = kk
    static as double h = kk / 2
    print z, h
end sub

planet( )
scalar( )
