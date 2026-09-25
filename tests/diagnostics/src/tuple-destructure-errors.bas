'' Tuple errors from fbc's errors/tuple-errors.bas (fbc-modern 1.20): 'extends' a tuple
'' (14) on line 11; destructuring too FEW (370) on 18 and too MANY (266) on 19; a UDT and a
'' scalar on the right (371) on 20 and 21; 'var' with one name (367) on 22, the wrong arity
'' (370) on 23, and a scalar (371) on 24. Lines 26 to 28 are accepted -- 'let ( ... ) = udt'
'' is FreeBASIC's multiple assignment, fields in order, and not destructuring.
type U
    a as long
    b as long
end type
dim shared as (long, long) t2 : dim shared as (long, long, long) t3
type Derived extends (long, long)
    f as long
end type
dim shared as U u1
sub s( )
    dim as long x, y, z

    (x, y) = t3
    (x, y, z) = t2
    (x, y) = u1
    (x, y) = 42
    var (a1) = 1
    var (b1, b2, b3) = (1, 2)
    var (c1, c2) = 42

    (x, y) = t2
    var (d1, d2) = (1, 2)
    let (x, y) = u1
end sub
