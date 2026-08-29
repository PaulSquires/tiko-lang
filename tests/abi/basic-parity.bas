'' basic-parity.bas -- differential for fb_StrLen, fb_ASC, fb_LEFT, fb_RIGHT.
''
'' This began as PROBE-27, written BEFORE the implementation existed, and is kept
'' verbatim as the differential. That is the intended shape: the probe that
'' establishes a contract is exactly the test that defends it.
''
'' It prints the temp bit and the data pointer, not just the value, because two
'' of the contracts here are about those rather than about the characters:
'' fb_ASC is 1-based with 0 out of range, and a degenerate LEFT/RIGHT returns an
'' unowned descriptor with NULL data and the temp bit CLEAR.
#include once "fbc-int/string.bi"
extern "rtlib"
    declare function p_Len   alias "fb_StrLen" ( byval s as any ptr, byval sz as integer ) as integer
    declare function p_Asc   alias "fb_ASC" ( byval s as FBC.FBSTRING ptr, byval pos as integer ) as ulong
    declare function p_Left  alias "fb_LEFT" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
    declare function p_Right alias "fb_RIGHT" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
end extern

sub shw( byval tag as zstring ptr, byval d as FBC.FBSTRING ptr )
    if( d = 0 ) then print *tag; " -> NULL" : exit sub
    print *tag; " -> len="; (d->len and &h7fffffffffffffff); " size="; d->size; _
          " temp="; iif( d->len < 0, "Y", "n" ); " ["; iif( d->data = 0, "NULLDATA", *d->data ); "]"
end sub

dim as string v = "abcdef"
dim as zstring * 12 z = "abcdef"
dim as string emp = ""

print "-- fb_StrLen, the four argument forms"
print "  varlen(-1)    = "; p_Len( cptr( any ptr, @v ), -1 )
print "  zstring ptr(0)= "; p_Len( cptr( any ptr, @z ), 0 )
print "  fixed zstr(12)= "; p_Len( cptr( any ptr, @z ), 12 )
print "  NULL,-1       = "; p_Len( 0, -1 )
print "  NULL,0        = "; p_Len( 0, 0 )
print "  empty varlen  = "; p_Len( cptr( any ptr, @emp ), -1 )

print "-- fb_ASC( ""abcdef"", pos )"
for p as integer = 0 to 3
    print "  pos="; p; " -> "; p_Asc( cptr( FBC.FBSTRING ptr, @v ), p )
next
print "  pos=99  -> "; p_Asc( cptr( FBC.FBSTRING ptr, @v ), 99 )
print "  empty,1 -> "; p_Asc( cptr( FBC.FBSTRING ptr, @emp ), 1 )
print "  NULL,1  -> "; p_Asc( 0, 1 )

print "-- fb_LEFT"
shw( @"  LEFT(abcdef,3) ", p_Left( cptr( FBC.FBSTRING ptr, @v ), 3 ) )
shw( @"  LEFT(abcdef,0) ", p_Left( cptr( FBC.FBSTRING ptr, @v ), 0 ) )
shw( @"  LEFT(abcdef,-2)", p_Left( cptr( FBC.FBSTRING ptr, @v ), -2 ) )
shw( @"  LEFT(abcdef,99)", p_Left( cptr( FBC.FBSTRING ptr, @v ), 99 ) )
shw( @"  LEFT(empty,3)  ", p_Left( cptr( FBC.FBSTRING ptr, @emp ), 3 ) )
shw( @"  LEFT(NULL,3)   ", p_Left( 0, 3 ) )

print "-- fb_RIGHT"
shw( @"  RIGHT(abcdef,3) ", p_Right( cptr( FBC.FBSTRING ptr, @v ), 3 ) )
shw( @"  RIGHT(abcdef,0) ", p_Right( cptr( FBC.FBSTRING ptr, @v ), 0 ) )
shw( @"  RIGHT(abcdef,-2)", p_Right( cptr( FBC.FBSTRING ptr, @v ), -2 ) )
shw( @"  RIGHT(abcdef,99)", p_Right( cptr( FBC.FBSTRING ptr, @v ), 99 ) )
shw( @"  RIGHT(empty,3)  ", p_Right( cptr( FBC.FBSTRING ptr, @emp ), 3 ) )
shw( @"  RIGHT(NULL,3)   ", p_Right( 0, 3 ) )

print "-- LEFT/RIGHT CONSUME a temporary operand (PROBE-28)"
scope
    dim as FBC.FBSTRING ptr src = p_AllocTemp( 0, 6 )
    src->data[0] = asc("a") : src->data[1] = asc("b") : src->data[2] = asc("c")
    src->data[3] = asc("d") : src->data[4] = asc("e") : src->data[5] = asc("f")
    src->data[6] = 0
    dim as FBC.FBSTRING ptr r = p_Left( src, 3 )

    '' CAPTURE FIRST, PRINT AFTER. A released descriptor goes straight back on
    '' the 256-entry free list, and PRINT itself allocates temporaries -- so a
    '' check written after the print observes whatever reclaimed the slot, not
    '' what LEFT left behind. The first version of this read len=22 for exactly
    '' that reason. Same shape as PRINT clearing ERR in error-parity.bas.
    dim as integer srcLen = cint( src->len and &h7fffffffffffffff )
    dim as integer srcHeld = iif( src->data = 0, 0, 1 )
    dim as integer srcTemp = iif( src->len < 0, 1, 0 )
    dim as integer rHeld = iif( r->data = 0, 0, 1 )

    print "  LEFT(temp,3) result held="; rHeld
    print "  source after : len="; srcLen; " held="; srcHeld; " temp="; srcTemp
end scope
scope
    dim as string v2 = "abcdef"
    dim as FBC.FBSTRING ptr pv = cptr( FBC.FBSTRING ptr, @v2 )
    p_Right( pv, 3 )
    dim as integer pvLen = cint( pv->len )
    dim as integer pvHeld = iif( pv->data = 0, 0, 1 )
    print "  non-temp after: len="; pvLen; " held="; pvHeld
end scope
