'' HEX, OCT AND BIN OF A FLOAT. fbc rounds the value to an integer first, halves to
'' even, and picks the entry point by the float's PRECISION: a DOUBLE is
'' 'fb_HEX_l( fb_D2UL( D ) )', a SINGLE 'fb_HEX_i( (uint32)fb_F2L( F ) )'. tiko declined
'' every one of these, so 'print hex( d )' printed nothing. A USING-imported
'' 'hex( byval as double )' is hidden by the builtin, so it takes the same path.
''
'' fbc prints:
''   2 2 FFFFFFFFFFFFFFFE FFFFFFFFFFFFFFFF 2540BE400 8AC7230489E80000
''   4 FFFFFFFF B2D05E00
''   2 10 1777777777777777777777 11111111111111111111111111111111
''   0002 FFFF 000004 00000010
''    16 11 2
''   2 FFFFFFFFFFFFFFFE 4
''   s:2 FF 2
namespace N
    function hex( byval d as double ) as string
        return "nshexdbl"
    end function
end namespace

dim as double d = 1.5
dim as double d2 = 2.5
dim as double dn = -1.5
dim as double dm = -1
dim as double big = 1e10
dim as double huge = 1e19
dim as single sg = 3.5
dim as single sn = -1
dim as single sbig = 3e9
print hex( d ); " "; hex( d2 ); " "; hex( dn ); " "; hex( dm ); " "; hex( big ); " "; hex( huge )
print hex( sg ); " "; hex( sn ); " "; hex( sbig )
print oct( d ); " "; bin( d2 ); " "; oct( dm ); " "; bin( sn )
print hex( d, 4 ); " "; hex( dm, 4 ); " "; oct( sg, 6 ); " "; bin( d, 8 )
print len( whex( dm ) ); len( woct( sn ) ); len( wbin( d2 ) )
print hex( 1.5 ); " "; hex( -2.5 ); " "; hex( 3.5! )
using N
dim as string s = hex( d ) & " " & hex( 255 ) & " " & ..hex( d )
print "s:"; s
