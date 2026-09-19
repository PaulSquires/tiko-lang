'' A CONSTANT STRING ARGUMENT IS A LITERAL: a ZSTRING, or a WSTRING with a unicode escape.
'' A named CONST STRING is one tier down against a byval string. Each body prints what it got.
declare sub g overload( byval a as long, byval s as string )
declare sub g( byval a as long, byval s as zstring ptr )
sub g( byval a as long, byval s as string )
    print "g string"; a; " "; s
end sub
sub g( byval a as long, byval s as zstring ptr )
    print "g zptr"; a; " "; *s
end sub
declare sub h overload( s as string )
declare sub h( byval s as wstring ptr )
sub h( s as string )
    print "h string "; s
end sub
sub h( byval s as wstring ptr )
    print "h wptr "; *s
end sub
declare sub k overload( byval s as string )
declare sub k( byref s as zstring )
sub k( byval s as string )
    print "k string "; s
end sub
sub k( byref s as zstring )
    print "k zref "; s
end sub
const CZ = "cz"
dim as string sv = "sv"
dim as const string cs = "cs"
g( 1, "zz" )
g( 2, "a" & "b" )
g( 3, CZ )
g( 4, sv )
g( 5, sv & "!" )
g( 6, cs )
h( !"\u0041z" )
h( "narrow" )
k( "lit" )
k( sv )
