'' CONST AS AN OVERLOAD AXIS.
''
'' Measured by running these calls under fbc, and by compiling the rejected shapes on
'' their own:
''
''   d( x1 )   1     a non-const argument prefers the NON-const parameter
''   d( cx1 )  C1    a const argument takes the const one
''   e( x1 )   C1    ...and a non-const argument takes a const parameter when that is
''   e( cx1 )  C1    all there is, so adding const is ONE step, not a barrier
''
''   'byref x as T1' handed a CONST T1     fbc error 181, Invalid assignment/conversion
''   'byval x as T1' handed a CONST T1     accepted -- that is a copy
''   'byref x as integer' handed a const   error 181 too, so the rule is not about UDTs
''
'' Without the step the two candidates cost the SAME: the call bound to neither, the
'' expression stayed untyped, and the whole statement declined with nothing said.

type T1 extends object
end type

function d overload( byref x as const T1 ) as integer : return &hC1 : end function
function d overload( byref x as       T1 ) as integer : return &h01 : end function

function e overload( byref x as const T1 ) as integer : return &hC1 : end function

'' The pointer form is the same axis one level down: 'const T1 ptr' takes a 'T1 ptr',
'' and the caller's exact test cannot answer it because the const is on the POINTEE.
function g overload( byval p as const T1 ptr ) as integer : return &hC1 : end function
function h overload( byval p as       T1 ptr ) as integer : return &h01 : end function
function h overload( byval p as const T1 ptr ) as integer : return &hC1 : end function

dim x1 as T1
dim cx1 as const T1 = T1( )

print d( x1 ); d( cx1 ); e( x1 ); e( cx1 )
print g( @x1 ); g( @cx1 ); h( @x1 ); h( @cx1 )

'' Run under fbc the two lines print
''
''      1 193 193 193
''      193 193 1 193
''
'' -- 193 is &hC1. The golden's call targets say which overload each one chose.
