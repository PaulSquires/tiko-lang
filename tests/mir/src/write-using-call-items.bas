'' A CALL IS A DESCRIPTOR IN WRITE AND PRINT USING, with parentheses or without, and
'' 'wstr( u )' TRANSCODES rather than reading UTF-16 as bytes.
''
'' WRITE and the USING format both fell back on LowerAddr, which answers NOTHING for a
'' call -- so 'write f( )' and 'print using f( ); x' dropped the whole statement in
'' silence, while the paren-less spellings took the procedure's code address. Measured,
'' fbc passes the result to both, and converts a ustring before widening it:
''
''     FBSTRING* vr$11 = _ZN1T4GETSEi( &O$0, 0 );
''     fb_WriteString( 0, (FBSTRING*)vr$11, 1 );
''     vr$41 = fb_UStrToStr( (void*)&U$0, -1ll );
''     fb_StrAssign( (void*)&TMP$14$0, -1ll, (void*)vr$41, -1ll, 0 );
''     vr$43 = fb_StrToWstr( (char*)*(char**)&TMP$14$0 );
''
'' An N_CALL IS NOT ALWAYS A CALL -- 'write a( 1 )' over a string array is one too, and
'' it still passes its element's address.
''
'' fbc prints, one per line:
''     "s0"   "fs"   "arr"   "s0","fs","ps"
''     [x]   <fs>   arr
''     u0 lvU caf 3
type T
    dim as long x
    declare function GetS( byval n as long = 0 ) as string
    declare function GetU( byval n as long = 0 ) as ustring
    declare function Fmt( ) as string
    declare property PS( ) as string
end type

function T.GetS( byval n as long = 0 ) as string
    return "s" & n
end function

function T.GetU( byval n as long = 0 ) as ustring
    return "u" & n
end function

function T.Fmt( ) as string
    return "[&]"
end function

property T.PS( ) as string
    return "ps"
end property

function FreeS( ) as string
    return "fs"
end function

dim as T o
dim as ustring u = "lvU"
dim as string a( 1 to 2 )
a( 1 ) = "arr"

write o.GetS( )
write FreeS( )
write a( 1 )
write o.GetS( ), FreeS( ), o.PS

print using o.Fmt( ); "x"
print using "<&>"; FreeS( )
print using "&"; a( 1 )

print wstr( o.GetU( ) ); " "; wstr( u ); " "; wstr( "caf" ); " "; len( wstr( u ) )
