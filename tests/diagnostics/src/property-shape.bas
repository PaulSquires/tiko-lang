'' A PROPERTY'S SHAPE. fbc refuses lines 7, 8, 9, 10 and 19 (190, 191, 213; fbc-modern 1.20 and
'' 1.10.1, 2026-09-19). tiko takes any number of indices and a STATIC property (R13, R11), so it
'' refuses only line 8, a setter with no value, and line 19, a definition whose
'' two indices no declaration has.
type T
    x as long
    declare property g2( byval i as long, byval j as long ) as long
    declare property s0( )
    declare property s3( byval i as long, byval j as long, byval v as long )
    declare static property st( ) as long
    '' ACCEPTED: each legal shape.
    declare property g0( ) as long
    declare property g1( byval i as long ) as long
    declare property gn as long
    declare property s1( byval v as long )
    declare property s2( byval i as long, byval v as long )
end type
'' ...and a definition is held to the same shape as a declaration.
property T.g1( byval i as long, byval j as long ) as long
    return 0
end property
