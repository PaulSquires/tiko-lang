'' relocate.bas -- RFC 0018 P0, section 2: the relocations FreeBASIC ALREADY performs.
''
'' SWAP and REDIM PRESERVE move objects to new storage by their bytes and call no
'' structor. The RFC rests on this (V1) and its 'nomove' (V5) has to close both, so the
'' baseline pins them: no COPY and no LET line may appear in any case here.
''
'' Whether REDIM PRESERVE's realloc moved the block is not printed: realloc may grow in
'' place, so it is not deterministic. (Measured once, 1 -> 100,000 elements: it moved,
'' and still nothing was copied -- RFC 0018 section 11.)

#include once "count.bi"

type L
    items( any ) as long
    tag as T
end type

print "R1 swap p, q  (user copy ctor and let)"
scope
    dim as T p = T( 1 ), q = T( 2 )
    swap p, q
    print "  after: p=#" & p.id & " " & p.s & "  q=#" & q.id & " " & q.s
end scope
Report "R1"

print "R2 swap of two UDTs holding dynamic arrays"
scope
    dim as L p, q
    redim p.items( 2 ) : redim q.items( 3 )
    swap p, q
    print "  after: p ubound=" & ubound( p.items ) & " q ubound=" & ubound( q.items )
end scope
Report "R2"

print "R3 redim preserve 2 -> 8 elements"
scope
    redim as T a( 0 to 1 )
    dim as long first = a( 0 ).id
    print "  -- preserve"
    redim preserve a( 0 to 7 )
    print "  a(0) is " & iif( a( 0 ).id = first, "the same object", "ANOTHER object" ) & ", " & a( 0 ).s
end scope
Report "R3"

print "-- end of main"
