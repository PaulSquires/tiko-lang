'' wval-parity.bas -- the WSTRING number parsers, twenty-three entry points.
''
'' NEEDS-GEN-LLVM -- several are reserved names.
''
'' THE CASE THAT MATTERS MOST IS THE QB SIGN-BIT RULE: a prefixed literal that
'' fits in a QB INTEGER **IS** one, so &hFFFF parses as -1 and not 65535, while
'' &hFFFF& -- with the LONG suffix -- stays 65535. Nothing else in the family
'' behaves that way, and getting it wrong produces a number, never an error.
''
'' ALSO PINNED: the integer parsers call the UNSIGNED libc routine on purpose.
'' wcstol/wcstoll SATURATE, so VALINT("&hFFFFFFFF") would come back 2147483647
'' instead of -1. Both are asked for below.

extern "rtlib"
    declare function pVal      alias "fb_WstrVal"      ( byval s as wstring ptr ) as double
    declare function pToDouble alias "fb_WstrToDouble" ( byval s as wstring ptr, byval n as integer ) as double
    declare function pValInt   alias "fb_WstrValInt"   ( byval s as wstring ptr ) as long
    declare function pToInt    alias "fb_WstrToInt"    ( byval s as wstring ptr, byval n as integer ) as long
    declare function pValUInt  alias "fb_WstrValUInt"  ( byval s as wstring ptr ) as ulong
    declare function pToUInt   alias "fb_WstrToUInt"   ( byval s as wstring ptr, byval n as integer ) as ulong
    declare function pValLng   alias "fb_WstrValLng"   ( byval s as wstring ptr ) as longint
    declare function pToLng    alias "fb_WstrToLongint"( byval s as wstring ptr, byval n as integer ) as longint
    declare function pValULng  alias "fb_WstrValULng"  ( byval s as wstring ptr ) as ulongint
    declare function pToULng   alias "fb_WstrToULongint"( byval s as wstring ptr, byval n as integer ) as ulongint
    declare function pValBool  alias "fb_WstrValBool"  ( byval s as wstring ptr ) as byte
    declare function pToBool   alias "fb_WstrToBool"   ( byval s as wstring ptr, byval n as integer ) as byte
    declare function pR2I      alias "fb_WstrRadix2Int"     ( byval s as wstring ptr, byval n as integer, byval r as long ) as long
    declare function pR2L      alias "fb_WstrRadix2Longint" ( byval s as wstring ptr, byval n as integer, byval r as long ) as longint
    declare function pR2IQB    alias "fb_WstrRadix2IntQB"     ( byval s as wstring ptr, byval n as integer, byval r as long ) as long
    declare function pR2LQB    alias "fb_WstrRadix2LongintQB" ( byval s as wstring ptr, byval n as integer, byval r as long ) as longint
    declare function pToIntQB  alias "fb_WstrToIntQB"    ( byval s as wstring ptr, byval n as integer ) as long
    declare function pToUIntQB alias "fb_WstrToUIntQB"   ( byval s as wstring ptr, byval n as integer ) as ulong
    declare function pToLngQB  alias "fb_WstrToLongintQB"( byval s as wstring ptr, byval n as integer ) as longint
    declare function pToULngQB alias "fb_WstrToULongintQB"( byval s as wstring ptr, byval n as integer ) as ulongint
    declare function pToDblQB  alias "fb_WstrToDoubleQB" ( byval s as wstring ptr, byval n as integer ) as double
    declare function pBoolToW  alias "fb_BoolToWstr"   ( byval n as byte ) as wstring ptr
    declare function phBoolToW alias "fb_hBoolToWstr"  ( byval n as byte ) as wstring ptr
    declare sub      pWDel     alias "fb_WstrDelete"   ( byval s as wstring ptr )
end extern

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
    loop while( i < 40 )
    return o
end function

'' Every case goes through a wstring built from a literal, so the test text is
'' the same bytes on both runtimes.
dim shared as wstring * 40 w
sub setw( byref s as string )
    w = s
end sub
#define WN cint( len( *cptr( wstring ptr, @w ) ) )

sub row( byref tag as string, byref t as string )
    setw( t )
    print tag; " ["; t; "]"
    print "   val="; pVal( @w ); " int="; pValInt( @w ); " uint="; pValUInt( @w )
    print "   lng="; pValLng( @w ); " ulng="; pValULng( @w ); " bool="; pValBool( @w )
end sub

print "== decimal =="
row( "plain   ", "123" )
row( "negative", "-45" )
row( "spaces  ", "   77" )
row( "float   ", "3.5" )
row( "garbage ", "abc" )
row( "trailing", "12xy" )
row( "empty   ", "" )

print "== radix prefixes =="
row( "hex     ", "&hFF" )
row( "hex up  ", "&HFF" )
row( "oct     ", "&o17" )
row( "bin     ", "&b1011" )
row( "bare &  ", "&777" )
'' THE SATURATION CASE: a signed libc parser would clamp these.
row( "hex 32max", "&hFFFFFFFF" )
row( "hex 64max", "&hFFFFFFFFFFFFFFFF" )
row( "hex junk ", "&hFFZZ" )

'' THE 'd' EXPONENT: FreeBASIC accepts 1d5 for 1e5.
print "== d exponent =="
setw( "1d5" )  : print "1d5   val="; pVal( @w )
setw( "1D5" )  : print "1D5   val="; pVal( @w )
setw( "1e5" )  : print "1e5   val="; pVal( @w )
setw( "2.5d2" ): print "2.5d2 val="; pVal( @w )

print "== NULL =="
print "val="; pVal( 0 ); " int="; pValInt( 0 ); " lng="; pValLng( 0 ); " bool="; pValBool( 0 )

print "== bool =="
setw( "true" )  : print "true    = "; pValBool( @w )
setw( "TRUE" )  : print "TRUE    = "; pValBool( @w )
setw( "TrUe" )  : print "TrUe    = "; pValBool( @w )
setw( "false" ) : print "false   = "; pValBool( @w )
setw( "FALSE" ) : print "FALSE   = "; pValBool( @w )
setw( "0" )     : print "0       = "; pValBool( @w )
setw( "-0" )    : print "-0      = "; pValBool( @w )
setw( "0.0" )   : print "0.0     = "; pValBool( @w )
setw( "5" )     : print "5       = "; pValBool( @w )
setw( "xyz" )   : print "xyz     = "; pValBool( @w )
setw( "truex" ) : print "truex   = "; pValBool( @w )
print "hBoolToWstr 0 = ["; wtext( phBoolToW( 0 ) ); "]  1 = ["; wtext( phBoolToW( 1 ) ); "]"
dim as wstring ptr bw = pBoolToW( 1 )
print "BoolToWstr 1  = ["; wtext( bw ); "]" : pWDel( bw )
bw = pBoolToW( 0 )
print "BoolToWstr 0  = ["; wtext( bw ); "]" : pWDel( bw )

'' ---- the raw radix parsers. They stop at the first character that is not a
'' digit in the radix and return what they have -- no error, no end pointer.
print "== Radix2 =="
sub rrow( byref t as string, byval r as long )
    setw( t )
    print "R2 ["; t; "] radix"; r; " int="; pR2I( @w, WN, r ); " lng="; pR2L( @w, WN, r )
end sub
rrow( "FF", 16 )
rrow( "ff", 16 )
rrow( "FFZZ", 16 )
rrow( "17", 8 )
rrow( "19", 8 )
rrow( "1011", 2 )
rrow( "1021", 2 )
rrow( "FFFFFFFF", 16 )
rrow( "FFFFFFFFFFFFFFFF", 16 )
rrow( "", 16 )
'' An unsupported radix returns 0 without consuming anything.
rrow( "123", 10 )

'' ---- THE QB DIALECT AND ITS SIGN-BIT RULE.
print "== QB =="
sub qrow( byref t as string )
    setw( t )
    print "QB ["; t; "] int="; pToIntQB( @w, WN ); " uint="; pToUIntQB( @w, WN )
    print "      lng="; pToLngQB( @w, WN ); " ulng="; pToULngQB( @w, WN ); " dbl="; pToDblQB( @w, WN )
end sub
'' &hFFFF FITS IN A QB INTEGER, so it IS one -- sign bit and all.
qrow( "&hFFFF" )
'' The '&' LONG suffix keeps it 32 bits wide, so the same digits stay positive.
qrow( "&hFFFF&" )
qrow( "&h7FFF" )
qrow( "&h8000" )
qrow( "&hFFFFFFFF" )
qrow( "&hFFFFFFFFFF" )
qrow( "&o777" )
qrow( "&b1111111111111111" )
qrow( "123" )
qrow( "-45" )
qrow( "" )

'' The QB radix parsers on their own, where the rule is easiest to see.
print "== Radix2QB =="
sub qrrow( byref t as string, byval r as long )
    setw( t )
    print "QBR ["; t; "] radix"; r; " int="; pR2IQB( @w, WN, r ); " lng="; pR2LQB( @w, WN, r )
end sub
qrrow( "FFFF", 16 )
qrrow( "FFFF&", 16 )
qrrow( "7FFF", 16 )
qrrow( "8000", 16 )
qrrow( "FFFFFFFF", 16 )
qrrow( "FFFFFFFFFF", 16 )
qrrow( "177777", 8 )
qrrow( "1111111111111111", 2 )
