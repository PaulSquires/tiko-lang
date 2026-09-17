'' A UDT ARGUMENT TO AN RTL ENTRY POINT THAT TAKES A STRING DESCRIPTOR.
''
'' AfxNova's 'dylibload( p & "Lexilla64.dll" )' -- p a DWSTRING, so '&' is the user
'' operator returning another DWSTRING -- handed fb_DylibLoad the 24-byte UDT where an
'' FBSTRING* belongs. The runtime read a descriptor out of the object's bytes and
'' reported error 126 for a DLL sitting beside the exe: tiko-editor could not load
'' Scintilla. StrDescriptorOf_ declines a UDT and the value path then coerced the
'' aggregate to a pointer with nothing said.
''
'' Measured -- fbc converts through the type's own cast into a narrow temporary,
'' passes THAT, and deletes it at the end of the statement:
''
''     vr$8  = _Zv23catR2DWR8FBSTRING( &TMP$5, &P, &TMP$6 );
''     vr$9  = _ZN2DWcvwEv( vr$8 );
''     fb_WstrAssignToA( (void*)&TMP$7, -1ll, vr$9, 0 );
''     vr$12 = fb_DylibLoad( (FBSTRING*)&TMP$7 );
''     ... fb_StrDelete( (FBSTRING*)&TMP$7 );
''
'' Both spellings are here: 'dylibload' takes the descriptor in argument 0 and
'' 'dylibsymbol' in argument 1, and only the first was exercised by the editor.
type DW
    as wstring * 64 buf
    declare constructor( )
    declare operator cast( ) byref as const wstring
end type
constructor DW( ) : buf = "" : end constructor
operator DW.cast( ) byref as const wstring : return buf : end operator

operator &( byref a as DW, byref s as string ) as DW
    dim as DW r
    r.buf = a.buf & s
    return r
end operator

dim as DW p
p.buf = "kernel"
dim as any ptr h = dylibload( p & "32.dll" )
print "loaded="; iif( h <> 0, 1, 0 )
dim as DW s
s.buf = "Sle"
if h <> 0 then print "sym="; iif( dylibsymbol( h, s & "ep" ) <> 0, 1, 0 )
