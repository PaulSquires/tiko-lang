'' A USTRING ITEM HAS ITS OWN OUTPUT ENTRY POINT IN WRITE AND PRINT USING, as it does in
'' PRINT. Neither had one, so every ustring went out through fb_WriteString /
'' fb_PrintUsingStr, which read its UTF-16 buffer as narrow text: 'write u' wrote "lv"
'' for "lvU" and 'print using "&"; u' formatted "l". A ustring FORMAT was read the same
'' way, so "[&]" formatted with "[", and a 'ustring * N' format declined outright.
'' Measured, fbc:
''
''   write u          fb_WriteUStr( 0, &U$0, 1 )                     its own descriptor
''   write uf         fb_UStrAssign( &TMP, -1, UF$0, <tag>, 0 )      'ustring * N': a copy
''                    fb_WriteUStr( 0, &TMP, 1 ) ... fb_UStrDelete( &TMP )
''   write u1 & u2    fb_UStrConcat( &TMP1, ... ), the copy, the call, the delete
''   write o.GetU( )  vr = GETU( ), the copy, the call, the delete
''   print using u    vr = fb_UStrToStr( &U$0, -1ll ); fb_PrintUsingInit( vr )
''
'' and fb_PrintUsingUStr takes the same three shapes the write does. Neither entry point
'' releases the descriptor it is given, which is why the copy is deleted here.
''
'' fbc prints, one per line:
''     "ab"   "fix"   "fld"   "abcd"   "u0"   "u0"   "fu"   "pu"   "AB"   "litab"
''     "ab","nar","u0",42
''     ab   fix   abcd   u0   u0   fu   pu   AB
''     ab nar u0
''     [x]   <y>
type T
    dim as long x
    dim as ustring fu
    declare function GetU( byval n as long = 0 ) as ustring
    declare property PU( ) as ustring
end type

function T.GetU( byval n as long = 0 ) as ustring
    return "u" & n
end function

property T.PU( ) as ustring
    return "pu"
end property

function FreeU( ) as ustring
    return "fu"
end function

dim as T o
o.fu = "fld"
dim as ustring u1 = "ab", u2 = "cd"
dim as ustring * 10 uf = "fix"
dim as ustring ufmt = "[&]"
dim as ustring * 10 uffmt = "<&>"
dim as string s = "nar"

write u1
write uf
write o.fu
write u1 & u2
write o.GetU( )
write o.GetU
write FreeU
write o.PU
write ucase( u1 )
write "lit" & u1
write u1, s, o.GetU( ), 42

print using "&"; u1
print using "&"; uf
print using "&"; u1 & u2
print using "&"; o.GetU( )
print using "&"; o.GetU
print using "&"; FreeU
print using "&"; o.PU
print using "&"; ucase( u1 )
print using "& & &"; u1; s; o.GetU( )
print using ufmt; "x"
print using uffmt; "y"

'' The pool is 256 descriptors: a leaked copy per iteration would empty these.
for i as long = 1 to 400
    write o.GetU( )
next
for i as long = 1 to 400
    print using "&"; o.GetU
next
print "end"
