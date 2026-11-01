' An explicit constructor call that two constructors take equally.
type TT
    m as long
    declare constructor (byval p as wstring ptr)
    declare constructor (byval p as integer ptr)
    declare constructor (byref a as const wstring, byref b as wstring = "")
    declare constructor (byref a as const wstring, byref b as const wstring)
end type
constructor TT (byval p as wstring ptr) : m = 1 : end constructor
constructor TT (byval p as integer ptr) : m = 2 : end constructor
constructor TT (byref a as const wstring, byref b as wstring = "") : m = 3 : end constructor
constructor TT (byref a as const wstring, byref b as const wstring) : m = 4 : end constructor

sub f (byref x as TT)
end sub

dim t1 as TT = TT( 0 )
dim t2 as TT = TT( "x", "y" )
f( TT( 0 ) )
dim w as wstring * 4 = "a"
dim t3 as TT = TT( @w )
