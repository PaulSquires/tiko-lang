'' val-parity.bas -- the VAL family: fb_VAL, fb_VALINT, fb_VALUINT, fb_VALLNG,
'' fb_VALULNG, and the radix parsers beneath them.
''
'' The 64-bit forms are PLATFORM-CONDITIONAL (see src/str/vallng.tiko), so the
'' prefixed-overflow rows below are expected to read differently on Linux than
'' on Windows -- but identically between the two RUNTIMES on each, which is what
'' this compares.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function p_Val    alias "fb_VAL"     ( byval s as FBC.FBSTRING ptr ) as double
    declare function p_ValInt alias "fb_VALINT"  ( byval s as FBC.FBSTRING ptr ) as long
    declare function p_ValUInt alias "fb_VALUINT" ( byval s as FBC.FBSTRING ptr ) as ulong
    declare function p_ValLng alias "fb_VALLNG"  ( byval s as FBC.FBSTRING ptr ) as longint
    declare function p_ValULng alias "fb_VALULNG" ( byval s as FBC.FBSTRING ptr ) as ulongint
    declare function p_Rad    alias "fb_hStrRadix2Int" ( byval s as zstring ptr, byval n as integer, byval r as long ) as long
    declare function p_RadL   alias "fb_hStrRadix2Longint" ( byval s as zstring ptr, byval n as integer, byval r as long ) as longint
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
end extern

#define LN(p) cint( (p)->len and &h7fffffffffffffff )
#define D(v) cptr( FBC.FBSTRING ptr, @v )

sub t( byref v as string )
    dim as string s = v
    print "["; s; "] val="; p_Val( D(s) );
    dim as string s2 = v : print " int="; p_ValInt( D(s2) );
    dim as string s3 = v : print " uint="; p_ValUInt( D(s3) );
    dim as string s4 = v : print " lng="; p_ValLng( D(s4) );
    dim as string s5 = v : print " ulng="; p_ValULng( D(s5) )
end sub

'' plain decimals
t( "0" ) : t( "1" ) : t( "-1" ) : t( "42" ) : t( "-42" )
t( "3.5" ) : t( "-3.5" ) : t( ".5" ) : t( "1e3" ) : t( "1E3" )
'' the d/D exponent rewrite
t( "1d3" ) : t( "1D3" ) : t( "2.5d-2" )
'' leading whitespace: spaces only
t( "   7" ) : t( "  -7" )
t( !"\t7" ) : t( !"\n7" )
'' radix prefixes
t( "&h10" ) : t( "&H10" ) : t( "&hff" ) : t( "&hFF" ) : t( "&hFFzz" )
t( "&o17" ) : t( "&O17" ) : t( "&o19" )
t( "&b101" ) : t( "&B101" ) : t( "&b123" )
'' an unrecognised letter after & is octal with ONE char skipped
t( "&z12" ) : t( "&12" ) : t( "&x1F" )
'' 0x is deliberately refused
t( "0x10" ) : t( "0X10" ) : t( "0" ) : t( "01" )
'' junk and empties
t( "" ) : t( "abc" ) : t( "12abc" ) : t( "&" ) : t( "&h" )
'' decimal overflow wraps rather than saturating
t( "4294967295" ) : t( "4294967296" ) : t( "-2147483649" )
t( "18446744073709551615" ) : t( "18446744073709551616" )

'' the radix parsers directly, including the unknown-radix arm
dim as zstring * 16 z
sub r( byref v as string, byval radix as long )
    dim as zstring * 16 zz : zz = v
    print "rad("; v; ","; radix; ") = "; p_Rad( strptr(zz), len(v), radix ); "  lng="; p_RadL( strptr(zz), len(v), radix )
end sub
r( "FF", 16 ) : r( "ff", 16 ) : r( "7f", 16 ) : r( "FFzz", 16 )
r( "17", 8 ) : r( "19", 8 ) : r( "101", 2 ) : r( "123", 2 )
r( "10", 10 ) : r( "10", 0 ) : r( "10", 36 )
r( "", 16 )

'' NULL and operand consumption
print "VAL NULL     = "; p_Val( 0 )
print "VALINT NULL  = "; p_ValInt( 0 )
print "VALLNG NULL  = "; p_ValLng( 0 )

function mkTemp( byref v as string ) as FBC.FBSTRING ptr
    dim as FBC.FBSTRING ptr tp = p_AllocTemp( 0, len(v) )
    for i as integer = 0 to len(v) - 1 : tp->data[i] = v[i] : next
    tp->data[len(v)] = 0
    return tp
end function
dim as FBC.FBSTRING ptr q1 = mkTemp( "123" )
dim as double d1 = p_Val( q1 )
dim as integer a1 = LN(q1), a2 = iif(q1->data=0,0,1)
print "VAL temp = "; d1; " after len="; a1; " data="; a2
dim as FBC.FBSTRING ptr q2 = mkTemp( "&hFF" )
dim as long i2 = p_ValInt( q2 )
dim as integer a3 = LN(q2), a4 = iif(q2->data=0,0,1)
print "VALINT temp = "; i2; " after len="; a3; " data="; a4
