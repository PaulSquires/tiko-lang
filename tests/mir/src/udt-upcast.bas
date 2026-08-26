'' DERIVED TO BASE, as an argument.
''
'' A UDT reached NOTHING but its own type in the conversion table, so a T2 passed to a
'' 'byref x as T1' cost CONV_NONE. With ONE candidate that is not a diagnostic either:
'' the callee still binds, the call is emitted with a VOID result, and whatever consumed
'' it declines. Every upcast in the corpus went that way.
''
'' Measured by running these calls under fbc. The two lines print
''
''     1 2 2 1 1 1
''     1 1 2 2
''
'' -- the exact type wins, then the NEAREST base: offered { object, T1, T2 } a T3
'' argument takes T2, and offered { object, T1 } it takes T1. A base POINTER beats
'' 'any ptr', which is why 'pa( @x3 )' is 1 and not 9.

type T1 extends object
end type
type T2 extends T1
end type
type T3 extends T2
end type

function a overload( byref x as object ) as integer : return 0 : end function
function a overload( byref x as T1 ) as integer : return 1 : end function
function a overload( byref x as T2 ) as integer : return 2 : end function

function b overload( byref x as object ) as integer : return 0 : end function
function b overload( byref x as T1 ) as integer : return 1 : end function

function pa overload( byval p as any ptr ) as integer : return 9 : end function
function pa overload( byval p as T1 ptr ) as integer : return 1 : end function

function pb overload( byval p as object ptr ) as integer : return 0 : end function
function pb overload( byval p as T1 ptr ) as integer : return 1 : end function
function pb overload( byval p as T2 ptr ) as integer : return 2 : end function

'' The single-candidate case, which had no ambiguity to resolve and declined anyway.
function one( byref x as T1 ) as integer : return 7 : end function

dim x1 as T1
dim x2 as T2
dim x3 as T3

print a( x1 ); a( x2 ); a( x3 ); b( x1 ); b( x2 ); b( x3 )
print pa( @x3 ); pb( @x1 ); pb( @x2 ); pb( @x3 )
print one( x3 )
