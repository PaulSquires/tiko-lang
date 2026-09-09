'' THE FOUR SHAPES THAT ARE NOT fbc 227, each measured. Getting any of them wrong turns
'' a rule about ONE construct into a refusal of ordinary code.
''
'' A base destructor that is NOT VIRTUAL is not overridden at all.
type A1 extends object
    declare destructor pascal( )
end type
type B1 extends A1
end type

'' A virtual SUB is not implicitly overridden -- only the destructor is.
type A2 extends object
    declare virtual sub foo pascal( )
end type
type B2 extends A2
end type

'' stdcall and cdecl are ONE ABI on x86-64, so an implicit default matches either.
type A3 extends object
    declare virtual destructor stdcall( )
end type
type B3 extends A3
end type

'' ...and a derived type that declares the base's own convention is fine.
type A4 extends object
    declare virtual destructor pascal( )
end type
type B4 extends A4
    declare destructor pascal( )
end type

'' A CHAIN REPORTS ONCE, against the type whose implicit destructor differs. B5's is
'' default, so C5 inheriting THAT matches its own implicit one -- fbc reports one error
'' here, not two, and this file holds the accepted half of that pair.
type A5 extends object
    declare virtual destructor pascal( )
end type
type B5 extends A5
    declare destructor pascal( )
end type
type C5 extends B5
    declare destructor pascal( )
end type
