'' A string argument no constructor of a set takes. A set with a character-pointer
'' constructor is lowering's to build (CharPtrCtorInit_) and is fine.
type V
    as long kind
    declare constructor ( byval n as long )
    declare constructor ( byval d as double )
end type
constructor V ( byval n as long )
    kind = 1
end constructor
constructor V ( byval d as double )
    kind = 2
end constructor
type Z
    as long kind
    declare constructor ( byval n as long )
    declare constructor ( byval p as const zstring ptr )
end type
constructor Z ( byval n as long )
    kind = 1
end constructor
constructor Z ( byval p as const zstring ptr )
    kind = 3
end constructor
dim as string s = "y"
dim as V vx = V( "x" )
dim as V vy = V( s )
vx = V( "w" )
dim as Z zx = Z( "x" )
print vx.kind, vy.kind, zx.kind
