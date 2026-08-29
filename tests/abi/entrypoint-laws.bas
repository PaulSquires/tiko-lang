'' entrypoint-laws.bas -- the size laws of fb_hStrAlloc and fb_hStrRealloc,
'' measured by calling them DIRECTLY with a fresh descriptor.
''
'' The growth-law differential (alloc-parity.bas) sweeps `s = string(n,"a")`,
'' which reaches fb_hStrRealloc and never fb_hStrAlloc. So it cannot see
'' fb_hStrAlloc's law at all -- and the two are NOT the same: x32 versus x36.
'' That went unnoticed until a Linux gate failure forced the entry points to be
'' interrogated one at a time.
''
'' Also pins the thing that caused the crash: BOTH return a non-null data
'' pointer for length 0, while reporting size 0. fbc's callers write the
'' terminator unconditionally.

#include once "fbc-int/string.bi"

extern "rtlib"
    declare function p_Alloc alias "fb_hStrAlloc" _
        ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
    declare function p_Realloc alias "fb_hStrRealloc" _
        ( byval s as FBC.FBSTRING ptr, byval n as integer, byval k as long ) as FBC.FBSTRING ptr
end extern

dim as integer prev

print "-- fb_hStrAlloc: len -> size, steps only"
prev = -1
for n as integer = 0 to 300
    dim as FBC.FBSTRING d
    d.data = 0 : d.len = 0 : d.size = 0
    p_Alloc( @d, n )
    if( d.size <> prev ) then
        print "   len="; n; " size="; d.size; " data="; iif( d.data = 0, "NULL", "ok" )
        prev = d.size
    end if
next

for pres as integer = 0 to 1
    print "-- fb_hStrRealloc keepdata="; pres; " : len -> size, steps only"
    prev = -1
    for n as integer = 0 to 300
        dim as FBC.FBSTRING d
        d.data = 0 : d.len = 0 : d.size = 0
        p_Realloc( @d, n, iif( pres, -1, 0 ) )
        if( d.size <> prev ) then
            print "   len="; n; " size="; d.size; " data="; iif( d.data = 0, "NULL", "ok" )
            prev = d.size
        end if
    next
next

print "-- length 0 must still yield a writable buffer"
scope
    dim as FBC.FBSTRING d
    d.data = 0 : d.len = 0 : d.size = 0
    p_Alloc( @d, 0 )
    print "   hStrAlloc(0)   data="; iif( d.data = 0, "NULL", "ok" ); " size="; d.size
end scope
scope
    dim as FBC.FBSTRING d
    d.data = 0 : d.len = 0 : d.size = 0
    p_Realloc( @d, 0, -1 )
    print "   hStrRealloc(0) data="; iif( d.data = 0, "NULL", "ok" ); " size="; d.size
end scope
