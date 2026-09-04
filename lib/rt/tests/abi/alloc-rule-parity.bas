'' alloc-rule-parity.bas -- fb_hStrAlloc / fb_hStrRealloc, over a GRID.
''
'' THIS FILE EXISTS BECAUSE THE OLD RULE SURVIVED FIFTEEN GATE RUNS.
''
'' fb_hStrRealloc's assign-mode resize test was `want <> size`, which shrinks on
'' any granule change. The real rule, measured rather than reasoned about:
''
''     grow    length > size                 (both modes)
''     shrink  want < size - (size >> 3)     (assign mode only -- 12.5%)
''
'' The two agree whenever the call arrives from a FRESH descriptor or from a
'' block far LARGER than the request, and every differential written before
'' 2026-08-29 did one or the other. Only fb_WstrAssignToAEx reached the
'' arrangement that separates them: a block from fb_hStrAlloc's x32 law
'' reassigned with a request that rounds by x36, so `want > size` while the
'' length still fits.
''
'' A SINGLE CASE WOULD NOT HAVE CAUGHT IT AND WILL NOT KEEP IT CAUGHT. The rule
'' has three regimes -- grow, hold, shrink -- and the boundaries between them are
'' where a future edit will go wrong. Both modes are swept, because they differ
'' in exactly one of the three.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function pAlloc   alias "fb_hStrAlloc"   ( byval s as any ptr, byval n as integer ) as any ptr
    declare function pRealloc alias "fb_hStrRealloc" ( byval s as any ptr, byval n as integer, byval k as long ) as any ptr
end extern

#define SLN(d) cint( (d)->len and cast( integer, &h7fffffffffffffffull ) )

'' fb_hStrAlloc's own law, on a FRESH descriptor every time -- it must not look
'' at what the descriptor already holds, so it is fed garbage deliberately.
print "-- hStrAlloc( fresh, n ) --"
for n as integer = 0 to 130 step 7
    dim as FBC.FBSTRING d
    d.data = cptr( zstring ptr, 12345 ) : d.len = 999 : d.size = 999
    pAlloc( cptr( any ptr, @d ), n )
    print using "n=### size=###"; n; d.size
    deallocate( d.data )
next

print "-- hStrRealloc from a grown block --"
for startlen as integer = 1 to 400 step 57
    for n as integer = 1 to 400 step 47
        for mode as integer = 0 to 1
            dim as string t
            dim as FBC.FBSTRING ptr q = cptr( FBC.FBSTRING ptr, @t )
            pRealloc( cptr( any ptr, @t ), startlen, 0 )
            dim as integer sz = q->size
            pRealloc( cptr( any ptr, @t ), n, mode )
            print using "start ### size ### -> n ### mode # size ### len ###"; _
                  startlen; sz; n; mode; q->size; SLN(q)
        next
    next
next

'' And from a block that came from hStrAlloc instead -- the x32 vs x36 mismatch
'' is precisely what the old rule got wrong.
print "-- hStrRealloc from an hStrAlloc block --"
for startlen as integer = 1 to 200 step 23
    for n as integer = 1 to 200 step 31
        for mode as integer = 0 to 1
            dim as string t
            dim as FBC.FBSTRING ptr q = cptr( FBC.FBSTRING ptr, @t )
            pAlloc( cptr( any ptr, @t ), startlen )
            dim as integer sz = q->size
            pRealloc( cptr( any ptr, @t ), n, mode )
            print using "alloc ### size ### -> n ### mode # size ### len ###"; _
                  startlen; sz; n; mode; q->size; SLN(q)
        next
    next
next
