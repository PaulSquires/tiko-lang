'' TKO0632 and TKO0806: a ustring handed to a constructor that wants a 'zstring ptr' --
'' fbc's errors 99 and 24. The controls at the bottom are accepted by fbc.
type T
    dim as string s
    declare constructor( byval z as zstring ptr )
end type
constructor T( byval z as zstring ptr )
    s = *z
end constructor
sub TZ overload ( byval z as zstring ptr )
end sub
sub TZ overload ( byval n as long )
end sub
dim as ustring u = "hello"

dim as T t1 = T( u )
dim as T t2 = u
dim as T t3 = T( u & "!" )
TZ( u )

'' Accepted by fbc: a lone procedure, a method, a 'byref as zstring' constructor, a
'' 'wstring ptr' one, and a set with a ustring constructor beside the zstring ptr one.
type TB
    dim as string s
    declare constructor( byref z as zstring )
end type
constructor TB( byref z as zstring )
    s = z
end constructor
type TW
    dim as wstring * 20 s
    declare constructor( byval z as wstring ptr )
end type
constructor TW( byval z as wstring ptr )
    s = *z
end constructor
type T2
    dim as string s
    declare constructor( byval z as zstring ptr )
    declare constructor( byref v as const ustring )
end type
constructor T2( byval z as zstring ptr )
    s = *z
end constructor
constructor T2( byref v as const ustring )
    s = v
end constructor
type TM
    dim as long k
    declare sub M( byval z as zstring ptr )
end type
sub TM.M( byval z as zstring ptr )
end sub
sub Lone( byval z as zstring ptr )
end sub
dim as TB b1 = TB( u )
dim as TW w1 = TW( u )
dim as T2 c1 = T2( u )
dim as T2 c2 = u
dim as TM m1
m1.M( u )
Lone( u )
dim as string n = "narrow"
dim as T t4 = T( n )
