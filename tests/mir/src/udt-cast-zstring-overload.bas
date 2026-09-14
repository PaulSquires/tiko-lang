'' A 'byref as zstring' cast result is a STRING, not a pointer to one. Measured on fbc,
'' offered { zstring ptr, byref string } the UDT takes the string:
''
''     char* vr$4 = _ZN1ZcvcEv( &ZV$0 );
''     _Z4PUT4R8FBSTRING( &TMP$3$0 );
''
'' and with only 'zstring ptr' on offer the same call is error 99 (overloaded) or 58.
type Z
    z as zstring * 8
    declare operator cast( ) byref as zstring
end type
operator Z.cast( ) byref as zstring
    return z
end operator
dim shared as long hit
dim as Z zv : zv.z = "hi"
sub Put4 overload( byval p as zstring ptr )
    hit = 1
end sub
sub Put4( byref s as string )
    hit = 2
end sub
Put4( zv )
print hit
