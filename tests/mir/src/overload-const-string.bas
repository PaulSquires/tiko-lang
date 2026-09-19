'' A NON-CONST STRING offered a CONST string parameter is one tier down: below zstring ptr
'' and byref zstring, above ustring and wstring -- and a string reaching a wide string is
'' dearer than a zstring ptr. Each body prints what it got.
declare sub g overload( byref s as const string )
declare sub g( byval s as const zstring ptr )
sub g( byref s as const string )
    print "g cstring "; s
end sub
sub g( byval s as const zstring ptr )
    print "g zptr "; *s
end sub
declare sub h overload( byref s as const string )
declare sub h( byref s as const zstring )
sub h( byref s as const string )
    print "h cstring "; s
end sub
sub h( byref s as const zstring )
    print "h zref "; s
end sub
declare sub k overload( byref s as const ustring )
declare sub k( byval s as const zstring ptr )
sub k( byref s as const ustring )
    print "k custring "; s
end sub
sub k( byval s as const zstring ptr )
    print "k zptr "; *s
end sub
declare sub m overload( byref s as const string )
declare sub m( byref s as const ustring )
sub m( byref s as const string )
    print "m cstring "; s
end sub
sub m( byref s as const ustring )
    print "m custring "; s
end sub
declare sub p overload( byval s as string )
declare sub p( byref s as const ustring )
sub p( byval s as string )
    print "p string "; s
end sub
sub p( byref s as const ustring )
    print "p custring "; s
end sub
declare sub q overload( byref s as const wstring )
declare sub q( byval s as const zstring ptr )
sub q( byref s as const wstring )
    print "q cwstring "; s
end sub
sub q( byval s as const zstring ptr )
    print "q zptr "; *s
end sub
dim as string sv = "sv"
dim as const string cs = "cs"
g( sv )
g( sv & "x" )
h( sv )
k( sv )
m( sv )
p( cs )
q( sv )
