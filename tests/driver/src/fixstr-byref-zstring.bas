'' A 'string * N' FOR A BYREF ZSTRING PARAMETER goes through a temporary and is copied
'' back (fbc-modern 1.20, 2026-09-28). Its N bytes are space-padded with no NUL after them,
'' and tiko passed them as they were: 'len( z )' ran on into the next variable, 10 where
'' fbc prints 8. The copy-back leaves the callee's NUL in the buffer, in fbc too, so
'' the byte after 'xyz' is printed as a number. See FixStrZArgTemp_ in src/mir/lowerbyref.bas.
sub PZ( byref z as zstring )
    print "len " & len( z ) & " [" & z & "]"
end sub
sub PZW( byref z as zstring )
    z = "xyz"
end sub
sub PZC( byref z as const zstring )
    print "const " & len( z )
end sub
type T
    a as string * 6
    b as long
end type
dim as ustring * 8 fu = "abc"
dim as wstring * 8 fw = "abcd"
dim as zstring * 8 fz = "ab"
dim as string * 8 fs = "a"
dim as ustring vu = "xyz"
dim as T t
t.a = "hi"
t.b = &h41414141
PZ( fs )
PZW( fs )
print "back [" & left( fs, 3 ) & "] " & asc( fs, 4 ) & " " & len( fs )
PZC( fs )
PZ( t.a )
PZW( t.a )
print "field [" & left( t.a, 3 ) & "] " & asc( t.a, 4 ) & " " & t.b
