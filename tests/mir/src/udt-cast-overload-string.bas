'' A UDT argument over an overload set, reached through its 'operator cast'. Measured on
'' fbc, a type shaped like AfxNova's BSTRING -- 'cast( ) byref as const wstring' and
'' 'cast( ) as any ptr' -- passed to { wstring ptr, byref string, byref D } takes the
'' STRING overload, through the wstring cast:
''
''     uint16* vr$1 = _ZN1BcvwEv( BS$1 );
''     fb_WstrAssignToA( (void*)&TMP$2$1, -1ll, vr$1, 0 );
''     _ZN1D3ADDER8FBSTRINGj( THIS$1, &TMP$2$1, 0u );
''
'' The 'any ptr' cast is never a candidate once the procedure is overloaded, and a
'' string result never decays to a string pointer.
type B extends wstring
    m as wstring ptr
    declare operator cast( ) byref as const wstring
    declare operator cast( ) as any ptr
end type
operator B.cast( ) byref as const wstring
    return *m
end operator
operator B.cast( ) as any ptr
    return m
end operator
type D
    n as long
    declare function Add( byval p as wstring ptr ) as boolean
    declare function Add( byref s as string, byval cp as ulong = 0 ) as boolean
    declare function Add( byref d as D ) as boolean
    declare sub AppendB( byref bs as B )
end type
function D.Add( byval p as wstring ptr ) as boolean
    n = 1 : return true
end function
function D.Add( byref s as string, byval cp as ulong = 0 ) as boolean
    n = 2 : return true
end function
function D.Add( byref d as D ) as boolean
    n = 3 : return true
end function
sub D.AppendB( byref bs as B )
    this.Add( bs )
end sub
dim as wstring * 8 w = "hi"
dim as B bv : bv.m = @w
dim as D x
x.AppendB( bv )
print x.n
