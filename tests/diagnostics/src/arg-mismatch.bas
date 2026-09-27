'' An argument that cannot convert, at a call with ONE candidate: fbc's error 58 or 24,
'' one per line from line 34 on. See tests/diagnostics/arg-mismatch.test.

type T
    as long v
    declare sub m( )
end type

type U
    as double w
end type

function fnp( ) as long : return 1 : end function
function takeTptr( byval p as T ptr ) as long : return 1 : end function
function takeAny( byval p as any ptr ) as long : return 1 : end function
function takeZptr( byval p as zstring ptr ) as long : return 1 : end function
function takeStr( byval p as string ) as long : return 1 : end function
function takeRStr( byref p as string ) as long : return 1 : end function
function takeRZ( byref p as zstring ) as long : return 1 : end function
function takeFn( byval p as function( ) as long ) as long : return 1 : end function
function takeLong( byval p as long ) as long : return 1 : end function
function takeDbl( byval p as double ) as long : return 1 : end function
function takeRLong( byref p as long ) as long : return 1 : end function
function takeRT( byref p as T ) as long : return 1 : end function
function takeU( byval p as U ) as long : return 1 : end function

dim shared as T t1
dim as T ptr tp = @t1
dim as long i1 = 3
dim as double d1 = 2.5
dim as boolean bo = true
dim as string s1 = "x"

print takeTptr( t1 )
print takeAny( t1 )
print takeZptr( t1 )
print takeStr( t1 )
print takeRStr( t1 )
print takeRZ( t1 )
print takeFn( t1 )
print takeLong( tp )
print takeDbl( tp )
print takeRLong( tp )
print takeRT( tp )
print takeRZ( tp )
print takeLong( @fnp )
print takeLong( @t1 )
print takeLong( cptr( any ptr, 5 ) )
print takeTptr( i1 )
print takeTptr( d1 )
print takeTptr( bo )
print takeU( s1 )
print takeU( "abc" )

'' 'this' is the OBJECT, so it is not a 'T ptr' either.
sub T.m( )
    print takeTptr( this )
end sub
