'' A PAREN-LESS STRING CALL IS A CALL IN EVERY READER. PRINT took a bare METHOD -- 'print
'' o.GetS', 'print T.StS' -- for its address, and WRITE, PRINT USING (item and format),
'' 'wstr( )' and a string 'iif' arm did the same for every bare procedure, free functions
'' and properties included. LowerAddr's answer for a procedure is its CODE address, so
'' the runtime was handed machine code as a descriptor and either printed nothing or
'' crashed. Measured, fbc calls each one and passes the result:
''
''     FBSTRING* vr$3 = _ZN1T4GETSEi( &O$0, 0 );
''     fb_PrintString( 0, (FBSTRING*)vr$3, 1 );         and fb_WriteString, fb_PrintUsingStr
''
'' fbc prints, one per line:
''     s0   u0   sts   sts   ps   pu   fs   fu
''     "s0","fs","ps","sts"
''     [s0] fs ps sts
''     s0fsps
''     s0 ps
type T
    dim as long x
    declare function GetS( byval n as long = 0 ) as string
    declare function GetU( byval n as long = 0 ) as ustring
    declare function Fmt( ) as string
    declare property PS( ) as string
    declare property PU( ) as ustring
    declare static function StS( ) as string
end type

function T.GetS( byval n as long = 0 ) as string
    return "s" & n
end function

function T.GetU( byval n as long = 0 ) as ustring
    return "u" & n
end function

function T.Fmt( ) as string
    return "[&] & & &"
end function

property T.PS( ) as string
    return "ps"
end property

property T.PU( ) as ustring
    return "pu"
end property

static function T.StS( ) as string
    return "sts"
end function

function FreeS( ) as string
    return "fs"
end function

function FreeU( ) as ustring
    return "fu"
end function

dim as T o
dim as long b = 1
print o.GetS
print o.GetU
print T.StS
print o.StS
print o.PS
print o.PU
print FreeS
print FreeU
write o.GetS, FreeS, o.PS, T.StS
print using o.Fmt; o.GetS; FreeS; o.PS; T.StS
print wstr( o.GetS ); wstr( FreeS ); wstr( o.PS )
print iif( b, o.GetS, "no" ); " "; iif( b = 0, "no", o.PS )
