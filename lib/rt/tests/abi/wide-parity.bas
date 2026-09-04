'' wide-parity.bas -- differential for the wide-string entry points.
''
'' Same binary, linked against each runtime, output diffed. Covers what PROBE-19
'' established and the edges around it: trim removes ONLY 0x20, so every other
'' whitespace character must survive, and an all-space string must come back
'' empty rather than NULL.

extern "rtlib"
    declare function p_Trim  alias "fb_WstrTrim"  ( byval s as wstring ptr ) as wstring ptr
    declare function p_LTrim alias "fb_WstrLTrim" ( byval s as wstring ptr ) as wstring ptr
    declare function p_RTrim alias "fb_WstrRTrim" ( byval s as wstring ptr ) as wstring ptr
    declare function p_Len   alias "fb_WstrLen"   ( byval s as wstring ptr ) as integer
    declare function p_Comp  alias "fb_WstrCompare" ( byval a as wstring ptr, byval b as wstring ptr ) as long
    declare sub      p_WDel  alias "fb_WstrDelete" ( byval s as wstring ptr )
end extern

sub dump( byval tag as zstring ptr, byval r as wstring ptr )
    print *tag; ": ";
    if( r = 0 ) then
        print "NULL"
        exit sub
    end if
    print "len="; len(*r); " [";
    for i as integer = 0 to len(*r) - 1
        print hex( (*r)[i], 2 ); " ";
    next
    print "]"
end sub

dim as wstring * 64 w
dim as wstring ptr r

print "-- every whitespace but 0x20 must survive"
w = wchr(&h20) + wchr(&h09) + wchr(&h0A) + wchr(&h0B) + wchr(&h0C) + wchr(&h0D) + wstr("X") + _
    wchr(&h0D) + wchr(&h0C) + wchr(&h0B) + wchr(&h0A) + wchr(&h09) + wchr(&h20)
r = p_Trim( @w )  : dump( @"  Trim ", r ) : p_WDel( r )
r = p_LTrim( @w ) : dump( @"  LTrim", r ) : p_WDel( r )
r = p_RTrim( @w ) : dump( @"  RTrim", r ) : p_WDel( r )

print "-- ordinary"
w = wstr("   hello   ")
r = p_Trim( @w )  : dump( @"  Trim ", r ) : p_WDel( r )
r = p_LTrim( @w ) : dump( @"  LTrim", r ) : p_WDel( r )
r = p_RTrim( @w ) : dump( @"  RTrim", r ) : p_WDel( r )

print "-- all spaces"
w = wstr("     ")
r = p_Trim( @w ) : dump( @"  Trim ", r ) : p_WDel( r )

print "-- empty"
w = wstr("")
r = p_Trim( @w ) : dump( @"  Trim ", r ) : p_WDel( r )

print "-- nothing to trim"
w = wstr("abc")
r = p_Trim( @w ) : dump( @"  Trim ", r ) : p_WDel( r )

print "-- single space"
w = wstr(" ")
r = p_Trim( @w ) : dump( @"  Trim ", r ) : p_WDel( r )

print "-- interior spaces are kept"
w = wstr("  a b  c  ")
r = p_Trim( @w ) : dump( @"  Trim ", r ) : p_WDel( r )

print "-- empty results from LTrim / RTrim too"
w = wstr("     ")
r = p_LTrim( @w ) : dump( @"  LTrim", r ) : p_WDel( r )
r = p_RTrim( @w ) : dump( @"  RTrim", r ) : p_WDel( r )
w = wstr("")
r = p_LTrim( @w ) : dump( @"  LTrim", r ) : p_WDel( r )
r = p_RTrim( @w ) : dump( @"  RTrim", r ) : p_WDel( r )

print "-- len"
print "  len('')="; p_Len( @wstr("") ); " len('abc')="; p_Len( @wstr("abc") )

print "-- compare with NULL: a null operand is an EMPTY STRING"
dim as wstring * 8 emp = wstr("")
print "  (NULL,NULL)="; p_Comp( 0, 0 ); " (empty,NULL)="; p_Comp( @emp, 0 );
print " (NULL,empty)="; p_Comp( 0, @emp );
print " (abc,NULL)="; p_Comp( @wstr("abc"), 0 ); " (NULL,abc)="; p_Comp( 0, @wstr("abc") )
print "  Len(NULL)="; p_Len( 0 )
print "  Trim(NULL)="; iif( p_Trim( 0 ) = 0, "NULL", "non-null" )

print "-- compare"
dim as wstring * 8 a = wstr("abc"), b = wstr("abd"), c = wstr("abc"), d = wstr("ab")
print "  (abc,abd)="; p_Comp( @a, @b ); " (abc,abc)="; p_Comp( @a, @c );
print " (abd,abc)="; p_Comp( @b, @a ); " (abc,ab)="; p_Comp( @a, @d ); " (ab,abc)="; p_Comp( @d, @a )
