'' valqb-bool-parity.bas -- the QB-dialect parsers and the bool parser.
''
'' The QB width rule is the whole point: a radix literal that fits in 16 bits
'' becomes a SIGNED 16-bit value, sign bit and all, unless the `&` LONG suffix
'' keeps it 32 bits wide.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function p_RadQB  alias "fb_hStrRadix2IntQB"     ( byval s as zstring ptr, byval n as integer, byval r as long ) as long
    declare function p_RadLQB alias "fb_hStrRadix2LongintQB" ( byval s as zstring ptr, byval n as integer, byval r as long ) as longint
    declare function p_IntQB  alias "fb_hStr2IntQB"    ( byval s as zstring ptr, byval n as integer ) as long
    declare function p_UIntQB alias "fb_hStr2UIntQB"   ( byval s as zstring ptr, byval n as integer ) as ulong
    declare function p_LngQB  alias "fb_hStr2LongintQB"  ( byval s as zstring ptr, byval n as integer ) as longint
    declare function p_ULngQB alias "fb_hStr2ULongintQB" ( byval s as zstring ptr, byval n as integer ) as ulongint
    declare function p_DblQB  alias "fb_hStr2DoubleQB" ( byval s as zstring ptr, byval n as integer ) as double
    declare function p_ValQB  alias "fb_VALQB"   ( byval s as FBC.FBSTRING ptr ) as double
    declare function p_Bool   alias "fb_hStr2Bool" ( byval s as zstring ptr, byval n as integer ) as byte
    declare function p_ValBool alias "fb_VALBOOL" ( byval s as FBC.FBSTRING ptr ) as byte
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
end extern

#define LN(p) cint( (p)->len and &h7fffffffffffffff )
#define D(v) cptr( FBC.FBSTRING ptr, @v )

sub qb( byref v as string )
    dim as zstring * 40 z : z = v
    dim as integer n = len(v)
    print "["; v; "] intQB="; p_IntQB( strptr(z), n );
    print " uintQB="; p_UIntQB( strptr(z), n );
    print " lngQB="; p_LngQB( strptr(z), n );
    print " ulngQB="; p_ULngQB( strptr(z), n );
    print " dblQB="; p_DblQB( strptr(z), n )
end sub

'' the 16-bit narrowing, sign bit and all
qb( "&hFFFF" ) : qb( "&h7FFF" ) : qb( "&h8000" ) : qb( "&hFFFE" )
'' the & LONG suffix keeps it 32 bits
qb( "&hFFFF&" ) : qb( "&h8000&" )
'' 32-bit and wider
qb( "&hFFFFFFFF" ) : qb( "&h100000000" ) : qb( "&hFFFFFFFFFFFFFFFF" )
'' octal and binary
qb( "&o777" ) : qb( "&O177777" ) : qb( "&b1111111111111111" ) : qb( "&b101" )
'' the digit scanner is range-checked per radix
qb( "&b12" ) : qb( "&o19" ) : qb( "&hFFzz" )
'' decimal falls through to the ORDINARY parser -- QB has nothing to say
qb( "65535" ) : qb( "-1" ) : qb( "3.5" ) : qb( "1e3" )
'' prefixes and junk
qb( "&z12" ) : qb( "&12" ) : qb( "&" ) : qb( "&h" ) : qb( "" ) : qb( "   &hFF" )

'' the radix parsers directly, including the QB narrowing at each radix
sub rq( byref v as string, byval radix as long )
    dim as zstring * 40 z : z = v
    print "radQB("; v; ","; radix; ") = "; p_RadQB( strptr(z), len(v), radix ); " lng="; p_RadLQB( strptr(z), len(v), radix )
end sub
rq( "FFFF", 16 ) : rq( "8000", 16 ) : rq( "7FFF", 16 ) : rq( "FFFF&", 16 )
rq( "FFFFFFFF", 16 ) : rq( "177777", 8 ) : rq( "1111111111111111", 2 )
rq( "", 16 ) : rq( "zz", 16 ) : rq( "10", 10 )

'' VALQB through a descriptor, and operand consumption
dim as string qs = "&hFFFF"
print "VALQB       = "; p_ValQB( D(qs) )
print "VALQB NULL  = "; p_ValQB( 0 )
dim as string qe = ""
print "VALQB empty = "; p_ValQB( D(qe) )

function mkTemp( byref v as string ) as FBC.FBSTRING ptr
    dim as FBC.FBSTRING ptr tp = p_AllocTemp( 0, len(v) )
    for i as integer = 0 to len(v) - 1 : tp->data[i] = v[i] : next
    tp->data[len(v)] = 0
    return tp
end function
dim as FBC.FBSTRING ptr t1 = mkTemp( "&hFF" )
dim as double d1 = p_ValQB( t1 )
dim as integer a1 = LN(t1), a2 = iif(t1->data=0,0,1)
print "VALQB temp = "; d1; " after len="; a1; " data="; a2

'' ---- bool: the word, then the number
sub boolcase( byref v as string )
    dim as zstring * 40 z : z = v
    dim as string t = v
    print "bool ["; v; "] = "; p_Bool( strptr(z), len(v) ); "  VALBOOL="; p_ValBool( D(t) )
end sub
boolcase( "true" ) : boolcase( "TRUE" ) : boolcase( "True" ) : boolcase( "TrUe" )
boolcase( "false" ) : boolcase( "FALSE" ) : boolcase( "False" )
boolcase( "1" ) : boolcase( "0" ) : boolcase( "-1" ) : boolcase( "0.0" ) : boolcase( "-0.0" ) : boolcase( "0.1" )
boolcase( "&hFF" ) : boolcase( "&h0" ) : boolcase( "abc" ) : boolcase( "" ) : boolcase( "  true" ) : boolcase( "truex" )
print "VALBOOL NULL = "; p_ValBool( 0 )

'' VALBOOL consumes its operand too
dim as FBC.FBSTRING ptr t2 = mkTemp( "true" )
dim as byte b2 = p_ValBool( t2 )
dim as integer a3 = LN(t2), a4 = iif(t2->data=0,0,1)
print "VALBOOL temp = "; b2; " after len="; a3; " data="; a4
