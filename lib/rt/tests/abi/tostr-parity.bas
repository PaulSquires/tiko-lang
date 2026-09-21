'' tostr-parity.bas -- STR$ narrow and wide, plus the QB dialect: twenty-two
'' entry points.
''
'' NEEDS-GEN-LLVM -- fb_IntToStr and friends are reserved names.
''
'' THE QB VARIANTS DIFFER BY ONE CHARACTER -- the space flag, which puts a
'' leading blank on non-negative numbers. Every QB case below is printed inside
'' brackets so that blank is visible rather than swallowed by the terminal.
''
'' THE FAKED LENGTH IS ASSERTED DIRECTLY. The descriptor is allocated for the
'' worst case the formatter could produce and `len` is then set to the text that
'' came out, so `size` and `len` disagree. Both are published through
'' fbc-int/string.bi and a tighter allocation would be a visible divergence.
''
'' AND THE WIDE HALF IS FORMATTED NARROW AND WIDENED, which is only sound if the
'' text is identical -- so the same values go through both families and the two
'' outputs are printed next to each other.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function pI2S   alias "fb_IntToStr"       ( byval n as long ) as FBC.FBSTRING ptr
    declare function pU2S   alias "fb_UIntToStr"      ( byval n as ulong ) as FBC.FBSTRING ptr
    declare function pL2S   alias "fb_LongintToStr"   ( byval n as longint ) as FBC.FBSTRING ptr
    declare function pUL2S  alias "fb_ULongintToStr"  ( byval n as ulongint ) as FBC.FBSTRING ptr
    declare function pF2S   alias "fb_FloatToStr"     ( byval n as single ) as FBC.FBSTRING ptr
    declare function pD2S   alias "fb_DoubleToStr"    ( byval n as double ) as FBC.FBSTRING ptr
    declare function pB2S   alias "fb_BoolToStr"      ( byval n as byte ) as FBC.FBSTRING ptr
    declare function phB2S  alias "fb_hBoolToStr"     ( byval n as byte ) as zstring ptr
    declare function pI2SQ  alias "fb_IntToStrQB"     ( byval n as long ) as FBC.FBSTRING ptr
    declare function pU2SQ  alias "fb_UIntToStrQB"    ( byval n as ulong ) as FBC.FBSTRING ptr
    declare function pL2SQ  alias "fb_LongintToStrQB" ( byval n as longint ) as FBC.FBSTRING ptr
    declare function pUL2SQ alias "fb_ULongintToStrQB"( byval n as ulongint ) as FBC.FBSTRING ptr
    declare function pF2SQ  alias "fb_FloatToStrQB"   ( byval n as single ) as FBC.FBSTRING ptr
    declare function pD2SQ  alias "fb_DoubleToStrQB"  ( byval n as double ) as FBC.FBSTRING ptr
    declare function pI2W   alias "fb_IntToWstr"      ( byval n as long ) as wstring ptr
    declare function pU2W   alias "fb_UIntToWstr"     ( byval n as ulong ) as wstring ptr
    declare function pL2W   alias "fb_LongintToWstr"  ( byval n as longint ) as wstring ptr
    declare function pUL2W  alias "fb_ULongintToWstr" ( byval n as ulongint ) as wstring ptr
    declare function pF2W   alias "fb_FloatToWstr"    ( byval n as single ) as wstring ptr
    declare function pD2W   alias "fb_DoubleToWstr"   ( byval n as double ) as wstring ptr
    declare sub      pWDel  alias "fb_WstrDelete"     ( byval s as wstring ptr )
    declare function pSDel  alias "fb_hStrDelTemp"    ( byval s as any ptr ) as long
end extern

extern "c"
    declare function pF2Str alias "fb_hFloat2Str" _
        ( byval v as double, byval b as zstring ptr, byval d as long, byval m as long ) as zstring ptr
    declare function pFEx2W alias "fb_FloatExToWstr" _
        ( byval v as double, byval b as wstring ptr, byval d as long, byval m as long ) as wstring ptr
end extern

#define SLN(d) cint( (d)->len and cast( integer, &h7fffffffffffffffull ) )

function stext( byval p as FBC.FBSTRING ptr ) as string
    if( p = 0 ) then return "<NULL>"
    dim as string o = ""
    for i as integer = 0 to SLN(p) - 1
        o += chr( cptr( ubyte ptr, p->data )[i] )
    next
    return o
end function
function wtext( byval p as wstring ptr ) as string
    if( p = 0 ) then return "<NULL>"
    dim as ubyte ptr b = cptr( ubyte ptr, p )
    dim as string o = ""
    dim as integer i = 0
    do
        dim as ulongint v = 0
        for k as integer = 0 to sizeof( wstring ) - 1
            v or= cast( ulongint, b[i * sizeof( wstring ) + k] ) shl (k * 8)
        next
        if( v = 0 ) then return o
        o += chr( cint( v ) )
        i += 1
    loop while( i < 60 )
    return o
end function

'' ---- integers, narrow and wide side by side.
sub irow( byval n as longint )
    dim as FBC.FBSTRING ptr a = pI2S( cast( long, n ) )
    dim as FBC.FBSTRING ptr c = pL2S( n )
    dim as wstring ptr wa = pI2W( cast( long, n ) )
    dim as wstring ptr wc = pL2W( n )
    print "int "; n; "  narrow=["; stext( a ); "] wide=["; wtext( wa ); "]"
    print "        lng   =["; stext( c ); "] wide=["; wtext( wc ); "]"
    pSDel( a ) : pSDel( c ) : pWDel( wa ) : pWDel( wc )
end sub
print "== integers =="
irow( 0 )
irow( 1 )
irow( -1 )
irow( 2147483647 )
irow( -2147483648 )

dim as FBC.FBSTRING ptr s
dim as wstring ptr wp
s = pU2S( 4294967295ul )  : print "uint max  =["; stext( s ); "]" : pSDel( s )
wp = pU2W( 4294967295ul ) : print "uint max w=["; wtext( wp ); "]" : pWDel( wp )
s = pL2S( 9223372036854775807ll )  : print "lng max   =["; stext( s ); "]" : pSDel( s )
wp = pL2W( 9223372036854775807ll ) : print "lng max w =["; wtext( wp ); "]" : pWDel( wp )
s = pUL2S( 18446744073709551615ull )  : print "ulng max  =["; stext( s ); "]" : pSDel( s )
wp = pUL2W( 18446744073709551615ull ) : print "ulng max w=["; wtext( wp ); "]" : pWDel( wp )

'' ---- THE FAKED LENGTH: size is the worst case, len is the text.
s = pI2S( 7 )
print "IntToStr 7   len="; SLN(s); " size="; s->size; "  (size is the worst case)"
pSDel( s )
s = pD2S( 1.5 )
print "DoubleToStr  len="; SLN(s); " size="; s->size
pSDel( s )

'' ---- floats. The trailing-dot rule and the precision difference between
'' single (%.7g) and double (%.16g) are both visible here.
sub frow( byval d as double )
    dim as FBC.FBSTRING ptr a = pF2S( cast( single, d ) )
    dim as FBC.FBSTRING ptr b = pD2S( d )
    dim as wstring ptr wa = pF2W( cast( single, d ) )
    dim as wstring ptr wb = pD2W( d )
    print "flt ["; stext( a ); "] dbl ["; stext( b ); "]"
    print "  w ["; wtext( wa ); "]   w ["; wtext( wb ); "]"
    pSDel( a ) : pSDel( b ) : pWDel( wa ) : pWDel( wb )
end sub
print "== floats =="
frow( 0.0 )
frow( 1.0 )
frow( -1.0 )
frow( 0.5 )
frow( 3.14159265358979 )
frow( 1.0e100 )
frow( 1.0e-100 )
frow( 100000.0 )
frow( 1.0e20 )
frow( -0.0 )

'' NON-FINITE VALUES, BY BIT PATTERN. '0.0 / 0.0' is the NEGATIVE quiet NaN
'' (FFF8000000000000, the x86 "indefinite"), and a NaN's sign and payload are what
'' one printf keeps and another drops: fbc's sprintf is MinGW's and writes 'nan' for
'' every one of them, where the UCRT's writes '-nan(ind)' and '-nan'. The infinities
'' ride along because they are the other value %g has words for.
function dbits( byval b as ulongint ) as double
    return *cptr( double ptr, @b )
end function
frow( dbits( &hFFF8000000000000ull ) )
frow( dbits( &h7FF8000000000000ull ) )
frow( dbits( &hFFF8000000000001ull ) )
frow( dbits( &h7FF8000000000001ull ) )
frow( dbits( &h7FF0000000000000ull ) )
frow( dbits( &hFFF0000000000000ull ) )

print "== bool =="
print "hBoolToStr 0=["; *phB2S( 0 ); "] 1=["; *phB2S( 1 ); "]"
s = pB2S( 0 ) : print "BoolToStr 0 =["; stext( s ); "] len="; SLN(s) : pSDel( s )
s = pB2S( 1 ) : print "BoolToStr 1 =["; stext( s ); "] len="; SLN(s) : pSDel( s )

'' ---- THE QB DIALECT: one space, and it is the whole difference. Printed
'' inside brackets so the leading blank on non-negatives is visible.
print "== QB =="
sub qrow( byval n as longint )
    dim as FBC.FBSTRING ptr a = pI2SQ( cast( long, n ) )
    dim as FBC.FBSTRING ptr c = pL2SQ( n )
    print "QB int "; n; " =["; stext( a ); "]  lng=["; stext( c ); "]"
    pSDel( a ) : pSDel( c )
end sub
qrow( 0 )
qrow( 1 )
qrow( -1 )
qrow( 42 )
qrow( -42 )
s = pU2SQ( 7ul )   : print "QB uint 7  =["; stext( s ); "]" : pSDel( s )
s = pUL2SQ( 7ull ) : print "QB ulng 7  =["; stext( s ); "]" : pSDel( s )
s = pF2SQ( 1.5 )   : print "QB flt 1.5 =["; stext( s ); "]" : pSDel( s )
s = pF2SQ( -1.5 )  : print "QB flt -1.5=["; stext( s ); "]" : pSDel( s )
s = pD2SQ( 1.5 )   : print "QB dbl 1.5 =["; stext( s ); "]" : pSDel( s )
s = pD2SQ( -1.5 )  : print "QB dbl -1.5=["; stext( s ); "]" : pSDel( s )
'' ...and the space flag over a NaN of either sign: fbc gives ' nan' for both.
s = pF2SQ( dbits( &hFFF8000000000000ull ) ) : print "QB flt -nan=["; stext( s ); "]" : pSDel( s )
s = pD2SQ( dbits( &hFFF8000000000000ull ) ) : print "QB dbl -nan=["; stext( s ); "]" : pSDel( s )
s = pD2SQ( dbits( &h7FF8000000000000ull ) ) : print "QB dbl +nan=["; stext( s ); "]" : pSDel( s )
s = pD2SQ( dbits( &hFFF0000000000000ull ) ) : print "QB dbl -inf=["; stext( s ); "]" : pSDel( s )

'' ---- fb_hFloat2Str, and the ADDBLANK contract that makes it return a POINTER
'' rather than a length: the returned pointer is sometimes the buffer and
'' sometimes one past it, so a caller that uses its own buffer gets it wrong.
print "== hFloat2Str =="
dim as zstring * 64 fbuf
sub f2row( byval v as double, byval digits as long, byval mask as long )
    dim as zstring * 64 b
    for i as integer = 0 to 63 : b[i] = asc( "#" ) : next
    dim as zstring ptr r = pF2Str( v, @b, digits, mask )
    if( r = 0 ) then
        print "  v="; v; " d="; digits; " m="; mask; " -> <NULL>  buf0="; b[0]
    else
        print "  v="; v; " d="; digits; " m="; mask; " -> ["; *r; "]  offset="; _
              cint( cptr( ubyte ptr, r ) - cptr( ubyte ptr, @b ) )
    end if
end sub
f2row( 1.5, 7, 0 )
f2row( 1.5, 7, 1 )
f2row( -1.5, 7, 1 )
f2row( 0.0, 7, 1 )
f2row( 3.14159265358979, 16, 0 )
f2row( 1.0e100, 16, 1 )
f2row( 100000.0, 7, 0 )
'' A precision the fast path does not cover, so the format string is built.
f2row( 1.5, 3, 0 )
f2row( 1.5, 12, 1 )

'' ---- fb_FloatExToWstr: the same ADDBLANK contract, wide.
print "== FloatExToWstr =="
sub fwrow( byval v as double, byval digits as long, byval mask as long )
    dim as wstring * 64 b
    dim as wstring ptr r = pFEx2W( v, @b, digits, mask )
    print "  v="; v; " d="; digits; " m="; mask; " -> ["; wtext( r ); "]  atbase="; _
          iif( r = cptr( wstring ptr, @b ), 1, 0 )
end sub
fwrow( 1.5, 7, 0 )
fwrow( 1.5, 7, 1 )
fwrow( -1.5, 7, 1 )
fwrow( 0.0, 7, 1 )
fwrow( 3.14159265358979, 16, 0 )
fwrow( 100000.0, 7, 0 )
