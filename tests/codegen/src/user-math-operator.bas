#lang "fb"
type TSQR
    __ as integer
end type
operator sqr ( byref x as const TSQR ) as single
    operator = 16
end operator
type TABS
    __ as integer
end type
operator abs ( byref x as const TABS ) as single
    operator = 7
end operator
dim as TSQR s
dim as TABS a
print sqr( s )
print abs( a )

'' A DECLARATION OF A LIBM NAME THE EMITTER ALSO DECLARES.
declare function asinf cdecl alias "asinf" ( byval x as single ) as single
dim as single q = asinf( 0.5! )
print asin( 0.5! ) - q
