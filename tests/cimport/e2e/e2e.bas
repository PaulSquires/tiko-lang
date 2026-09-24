'' e2e.bas -- testlib.h through #cinclude, linked against clang's testlib.o and RUN.
'' build/cimporte2e.sh compares what this prints with e2e.expected.
#cinclude "tests/cimport/e2e/testlib.h"

function square cdecl( byval v as long, byval user as any ptr ) as long
    return v * v + *cptr( long ptr, user )
end function

dim as tl4_t v4 = tl_make4( 7 )
dim as tl8_t v8 = tl_make8( 3, 4 )
dim as tl12_t v12 = tl_make12( 1, 2, 3 )
dim as tl16_t v16 = tl_make16( 2.5, 4 )
dim as tl24_t v24 = tl_make24( 1.5, 2.5, 3.5 )
print "make", v4.a, v8.a; v8.b, v12.a; v12.b; v12.c, v16.x; v16.n, v24.x; v24.y; v24.z
print "sum", tl_sum4( v4 ), tl_sum8( v8 ), tl_sum12( v12 ), tl_sum16( v16 ), tl_sum24( v24 )
dim as long bonus = 1
print "apply", tl_apply( @square, @bonus, 1, 4 )
print "sumv", tl_sumv( 4, 10, 20, 30, 40 )
print "globals", tl_counter, *tl_name
tl_counter += 100
print "counter", tl_counter
print "macros", TL_VERSION
