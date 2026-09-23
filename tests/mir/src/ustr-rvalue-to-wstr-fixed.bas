'' A USTRING RVALUE INTO A 'wstring * N' converts through fb_UStrAssignToW. A call, a
'' method, a property or an intrinsic has no address, and the assignment took the scalar
'' path and STORED THE RETURNED DESCRIPTOR POINTER into the buffer -- eight bytes read as
'' text. fbx's example 'dim wszText as wstring * 260 = fbxGetWindowText( hCtl )' printed
'' garbage. Measured, fbc:
''
''   vr$0 = F( 5 );  fb_UStrAssignToW( W$0, 260ll, vr$0, -1ll )
''
'' tiko copies the result into a temporary and deletes it after; the text is the same.
type T
    dim as long k
    declare function GetU() as ustring
    declare property PU() as ustring
end type
function T.GetU() as ustring
    return "m" & k
end function
property T.PU() as ustring
    return "p" & k
end property
function F( byval n as long ) as ustring
    return "10.0.0." & n
end function
dim o as T
dim w as wstring * 260 = F( 5 )
w = F( 6 )
dim wa as wstring * 20 = o.GetU( )
dim wb as wstring * 20 = o.PU
dim uf as ustring * 10 = "fix"
dim we as wstring * 20 = uf
