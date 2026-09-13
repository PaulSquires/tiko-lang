'' INSTR and INSTRREV, narrow and wide, and where the START POSITION sits.
type UW
    as wstring * 50 s
    declare operator cast( ) byref as const wstring
end type
operator UW.cast( ) byref as const wstring
    return this.s
end operator

dim as string s = "hello", p = "l"
dim as wstring * 20 w, q
dim as UW wu, uq
dim as integer a

w = wstr( "hello" ) : q = wstr( "l" )

'' INSTR takes its start FIRST and passes it first.
a = instr( s, p )
a = instr( 2, s, p )
a = instr( s, any p )
a = instr( 2, s, any p )

'' INSTRREV takes its start THIRD and passes it last.
a = instrrev( s, p )
a = instrrev( s, p, 3 )
a = instrrev( s, any p )
a = instrrev( s, any p, 3 )

'' The wide half, including a UDT on either side or on both.
a = instr( w, q )
a = instr( 2, w, q )
a = instrrev( w, q, 3 )
a = instrrev( w, any q )
a = instr( wu, q )
a = instr( w, uq )
a = instr( wu, uq )
a = instrrev( wu, uq, 2 )
print a
