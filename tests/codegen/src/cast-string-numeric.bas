' cast( <number>, <string> ) PARSES the string, as the C-intrinsic of that type does: fbc's
' rtlStrToVal, fb_VALINT / VALUINT / VALLNG / VALULNG / VAL by the target's width and
' signedness. Every target type, over a variable, a call result, a member returning a
' string, a fixed zstring and a fixed wstring. (A ustring: cast-ustring-numeric-run -- fbc-modern's
' ustring is a class with no such cast, so there is no fbc output to hold it to.)

type Win
    nm as string
    declare function FontName( ) as string
end type
function Win.FontName( ) as string
    return nm
end function

function F( byref s as const string ) as string
    return s
end function

sub Row( byref s as string )
    print "[" & s & "]";
    print " b "; cast( byte, s ); " ub "; cast( ubyte, s ); " sh "; cast( short, s ); " ush "; cast( ushort, s );
    print " l "; cast( long, s ); " ul "; cast( ulong, s ); " i "; cast( integer, s ); " ui "; cast( uinteger, s );
    print " li "; cast( longint, s ); " uli "; cast( ulongint, s ); " sg "; cast( single, s ); " d "; cast( double, s );
    print " call "; cast( integer, F( s ) ); " "; cast( long, F( s ) ); " "; cast( double, F( s ) )
end sub

dim as string cases(0 to 10) = { "Segoe UI", "123", "2.7", "-2.5", "&hFF", "1e3", "  42abc", "", _
                                 "99999999999", "-1", "300" }
for i as long = 0 to 10
    Row( cases(i) )
next

dim as Win w
w.nm = "Segoe UI"
print "member "; cast( integer, w.FontName( ) )
w.nm = "77"
print "member "; cast( integer, w.FontName( ) )

dim as zstring * 8 z = "-31"
print "zstring "; cast( integer, z ); " "; cast( ulong, z )
dim as wstring * 8 ws = "65"
print "wstring "; cast( integer, ws ); " "; cast( double, ws )
