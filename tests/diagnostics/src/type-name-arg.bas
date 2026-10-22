'' A type name passed as an argument: fbc's error 42 (or 1 or 9) at every line below.
'' José Roca's report: over windows.bi, 'Foo hInstance' spells the typedef HINSTANCE.
type HINSTANCE__
    as long unused
end type
type HINSTANCE as HINSTANCE__ ptr
type M as long
enum E : A : end enum
sub Foo ( byval hInst as HINSTANCE )
end sub
function g ( byval h as HINSTANCE ) as integer : return 0 : end function
dim fp as sub ( byval as long ) = 0
dim arr(3) as long
Foo hInstance
Foo( hInstance )
print g( hInstance )
fp( m )
print arr( m )
Foo e
