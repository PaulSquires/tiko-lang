'' A PROPERTY'S SHAPE -- fbc's errors 190, 191 and 213. A getter takes nothing or one
'' index, a setter its value with at most one index before it, and a property is never
'' STATIC. Each is refused on exactly the line fbc-modern 1.20 and 1.10.1 refuse it
'' (2026-09-19); tiko-lang accepted them all.
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
