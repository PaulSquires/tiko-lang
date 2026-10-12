'' ucore-parity.bas -- ustr_core.o: the USTRING allocator and its temp pool.
''
'' NEEDS-GEN-LLVM -- fb_UStrDelete is one of the names fbc reserves in its
'' rtlLookupTB, so aliasing it under -gen gcc produces conflicting C
'' declarations. The llvm backend takes the alias verbatim.
''
'' THE POINT OF THIS FILE is that the ustring allocator is NOT the narrow one at
'' a different width. It rounds to 16 CODE UNITS, adds 12.5% on top in realloc,
'' and only shrinks past a 12.5% hysteresis -- three laws the byte side does not
'' have. A "port" that reused src/str/core.tiko's arithmetic would pass every
'' behavioural test in the suite and report the wrong `size` for every ustring,
'' which fbc-int publishes and a program can read.
''
'' NOTHING IS PRINTED INSIDE A POOL SEQUENCE. PRINT allocates temporaries of its
'' own, and they take pool slots back the moment one is released -- a correctly
'' freed descriptor then reads as leaked. Results are recorded into arrays and
'' printed afterwards, which is the fourth time in this project that the
'' instrument had to be kept out of its own measurement.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function pU_Alloc     alias "fb_hUStrAlloc" _
        ( byval s as FBC.FBUSTRING ptr, byval n as integer ) as FBC.FBUSTRING ptr
    declare function pU_Realloc   alias "fb_hUStrRealloc" _
        ( byval s as FBC.FBUSTRING ptr, byval n as integer, byval k as long ) as FBC.FBUSTRING ptr
    declare sub      pU_Delete    alias "fb_UStrDelete" ( byval s as FBC.FBUSTRING ptr )
    declare function pU_TempDesc  alias "fb_hUStrAllocTempDesc" ( ) as FBC.FBUSTRING ptr
    declare function pU_DelDesc   alias "fb_hUStrDelTempDesc" ( byval s as FBC.FBUSTRING ptr ) as long
    declare function pU_AllocTmp  alias "fb_hUStrAllocTemp" _
        ( byval s as FBC.FBUSTRING ptr, byval n as integer ) as FBC.FBUSTRING ptr
    declare function pU_DelTmp    alias "fb_hUStrDelTemp" ( byval s as FBC.FBUSTRING ptr ) as long
end extern

type UDESC field = 1
    as any ptr  data_
    as integer  len_
    as integer  size_
end type

const TEMPBIT = &h8000000000000000ull
#define ULN(d) cint( (d).len_ and (not cast( integer, TEMPBIT )) )
#define UTEMP(d) iif( ((d).len_ and cast( integer, TEMPBIT )) <> 0, 1, 0 )
#define UD(v) cptr( FBC.FBUSTRING ptr, @v )

'' ---- fb_hUStrAlloc: the x16-unit law, on a FRESH descriptor every time.
'' Alloc must not look at what the descriptor already holds, so it is fed
'' garbage deliberately: this is the `dim as ustring u = "xy"` path.
print "-- hUStrAlloc( fresh, n ) -> len size --"
for n as integer = 0 to 40
    dim as UDESC d
    d.data_ = cptr( any ptr, 12345 ) : d.len_ = 999 : d.size_ = 999
    pU_Alloc( UD(d), n )
    print using "n=## len=## size=##"; n; ULN(d); d.size_
    pU_Delete( UD(d) )
next

'' ---- fb_hUStrRealloc: the +12.5% law and the shrink hysteresis.
'' One descriptor, walked up and then back down, so the hysteresis is exercised
'' from a size it actually reached rather than from a fresh allocation.
print "-- hUStrRealloc grow, keepdata=0 --"
dim as UDESC g
g.data_ = 0 : g.len_ = 0 : g.size_ = 0
for n as integer = 0 to 40
    pU_Realloc( UD(g), n, 0 )
    print using "n=## len=## size=##"; n; ULN(g); g.size_
next
print "-- hUStrRealloc shrink, keepdata=0 (hysteresis) --"
for n as integer = 40 to 0 step -1
    pU_Realloc( UD(g), n, 0 )
    print using "n=## len=## size=##"; n; ULN(g); g.size_
next
pU_Delete( UD(g) )

print "-- hUStrRealloc grow, keepdata=1 --"
dim as UDESC k
k.data_ = 0 : k.len_ = 0 : k.size_ = 0
for n as integer = 0 to 60
    pU_Realloc( UD(k), n, 1 )
    print using "n=## len=## size=##"; n; ULN(k); k.size_
next
print "-- hUStrRealloc shrink, keepdata=1 (must NOT shrink) --"
for n as integer = 60 to 0 step -8
    pU_Realloc( UD(k), n, 1 )
    print using "n=## len=## size=##"; n; ULN(k); k.size_
next
pU_Delete( UD(k) )

'' ---- the temp bit survives a realloc, and is cleared by Alloc and Delete.
dim as UDESC t
t.data_ = 0 : t.len_ = 0 : t.size_ = 0
pU_Realloc( UD(t), 10, 0 )
t.len_ or= cast( integer, TEMPBIT )
pU_Realloc( UD(t), 20, 1 )
print "temp bit after keepdata realloc: "; UTEMP(t); " len="; ULN(t)
pU_Realloc( UD(t), 4, 0 )
print "temp bit after assign realloc:   "; UTEMP(t); " len="; ULN(t)
pU_Alloc( UD(t), 7 )
print "temp bit after hUStrAlloc:       "; UTEMP(t); " len="; ULN(t)
pU_Delete( UD(t) )
print "after delete: data0="; iif( t.data_ = 0, 1, 0 ); " len="; t.len_; " size="; t.size_

'' ---- NULL and edge arguments
pU_Delete( 0 )
print "DelTempDesc( NULL )  = "; pU_DelDesc( 0 )
print "DelTemp( NULL )      = "; pU_DelTmp( 0 )
dim as UDESC own
own.data_ = 0 : own.len_ = 0 : own.size_ = 0
print "DelTempDesc( mine )  = "; pU_DelDesc( UD(own) )

'' ---- the pool: allocation order, reuse order, and the range check.
''
'' Descriptor ADDRESSES cannot be printed -- they differ between the two
'' runtimes and between runs. What is comparable is the STRIDE between
'' consecutive descriptors (the element size, which the ABI fixes) and whether a
'' released slot is handed straight back.
dim as FBC.FBUSTRING ptr slot(0 to 7)
dim as integer stride(0 to 7), reused(0 to 7), delrc(0 to 7)

for i as integer = 0 to 7
    slot(i) = pU_TempDesc( )
next
for i as integer = 1 to 7
    stride(i) = cint( cast( integer, slot(i) ) - cast( integer, slot(i-1) ) )
next
'' Release in reverse, then take them again: a LIFO free list hands the last
'' one released back first.
for i as integer = 7 to 0 step -1
    delrc(i) = pU_DelDesc( slot(i) )
next
dim as FBC.FBUSTRING ptr again(0 to 7)
for i as integer = 0 to 7
    again(i) = pU_TempDesc( )
next
for i as integer = 0 to 7
    reused(i) = -1
    for j as integer = 0 to 7
        if( again(i) = slot(j) ) then reused(i) = j
    next
next
for i as integer = 0 to 7
    pU_DelDesc( again(i) )
next

print "-- pool --"
for i as integer = 1 to 7
    print using "stride ## = ####"; i; stride(i)
next
for i as integer = 0 to 7
    print using "delrc ## = ###   reuse ## -> slot ###"; i; delrc(i); i; reused(i)
next

'' ---- AllocTemp / DelTemp, both argument forms.
''
'' The NULL form takes a descriptor from the pool; the supplied form does not,
'' so DelTemp must free the DATA in both cases and release the DESCRIPTOR in
'' only one -- which is the split that took three wrong versions on the narrow
'' side. The return code is what says which happened.
dim as FBC.FBUSTRING ptr tp = pU_AllocTmp( 0, 20 )
dim as UDESC ptr tpd = cptr( UDESC ptr, tp )
print "AllocTemp(NULL,20): null="; iif( tp = 0, 1, 0 ); _
      " len="; ULN(*tpd); " size="; tpd->size_; " temp="; UTEMP(*tpd)
print "DelTemp(pool)     = "; pU_DelTmp( tp )

dim as UDESC mine
mine.data_ = 0 : mine.len_ = 0 : mine.size_ = 0
pU_AllocTmp( UD(mine), 30 )
print "AllocTemp(mine,30): len="; ULN(mine); " size="; mine.size_; " temp="; UTEMP(mine)
dim as long rc = pU_DelTmp( UD(mine) )
print "DelTemp(mine)     = "; rc; _
      "  data0="; iif( mine.data_ = 0, 1, 0 ); " len="; mine.len_; " size="; mine.size_

'' A pool descriptor with the temp bit CLEAR is still handed back -- the
'' literal-backed case. Gating the whole of DelTemp on the temp bit is what
'' exhausted the narrow pool once, so it is asserted here rather than assumed:
'' if the slot is not released, the second AllocTempDesc returns a different one.
dim as FBC.FBUSTRING ptr lit = pU_TempDesc( )
dim as long litrc = pU_DelTmp( lit )
dim as FBC.FBUSTRING ptr lit2 = pU_TempDesc( )
print "DelTemp(pool, temp bit clear) = "; litrc; "  slot returned = "; iif( lit2 = lit, 1, 0 )
pU_DelDesc( lit2 )
