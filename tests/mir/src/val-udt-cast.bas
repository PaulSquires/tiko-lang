'' THE VAL AND CV FAMILIES OVER A UDT THAT CASTS TO A ZSTRING. A UDT has no string
'' descriptor of its own, so StrDescriptorOf_ answered no and 'valint( u )' declined --
'' while 's = u' beside it lowered, because the assignment path has known about the cast
'' all along. Measured:
''
''     vr  = _ZN2UZcvRcEv( &U$0 );
''     vr2 = fb_StrAllocTempDescZ( (char*)vr );
''     fb_VALINT( (FBSTRING*)vr2 )
''
'' -- the same borrow the LSET and MID paths already make. 'asc( u )' was given the WIDE
'' half of this treatment when it was written; this is the narrow half.
''
'' The operand also has to get PAST the family's non-string branch, which exists for
'' 'cvi( 1.58e40 )' and friends: a UDT is treated as a string operand there and the
'' descriptor branch decides, because UserCastToStr_ EMITS the call and cannot be asked
'' as a question. A UDT with no such cast reaches it and declines, exactly as before.
type UZ
    s as zstring * 16
    declare operator cast( ) byref as zstring
end type

operator UZ.cast( ) byref as zstring
    return this.s
end operator

dim u as UZ
u.s = "42"

print valint( u ), vallng( u ), valuint( u ), valulng( u )
