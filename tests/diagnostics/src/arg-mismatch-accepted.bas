'' The neighbours of tests/diagnostics/arg-mismatch.bas that fbc ACCEPTS, each measured:
'' none may be refused, and none may be dropped. See arg-mismatch-accepted.test.

type T
    as long v
    declare sub m( )
end type

'' A UDT with a way out, and one with a way in.
type CastP
    as long v
    declare operator cast( ) as T ptr
    declare operator cast( ) as string
end type
operator CastP.cast( ) as T ptr : return 0 : end operator
operator CastP.cast( ) as string : return "c" : end operator

type CtorS
    as long v
    declare constructor( byref s as string )
    declare constructor( byval p as T ptr )
end type
constructor CtorS( byref s as string ) : end constructor
constructor CtorS( byval p as T ptr ) : end constructor

type B
    as long v
end type
type D extends B
    as long w
end type

function takeTptr( byval p as T ptr ) as long : return 1 : end function
function takeStr( byval p as string ) as long : return 2 : end function
function takeLong( byval p as long ) as long : return 3 : end function
function takeRT( byref p as T ) as long : return 4 : end function
function takeC( byval p as CtorS ) as long : return 5 : end function
function takeBp( byval p as B ptr ) as long : return 6 : end function
function takeB( byval p as B ) as long : return 7 : end function

const KN = 0
dim shared as T t1
dim as T ptr tp = @t1
dim as long i1 = 3
dim as string s1 = "x"
dim as CastP cp1
dim as D d1
dim as D ptr dp = @d1

print takeLong( cptr( any ptr, 0 ) )     '' a NULL pointer constant binds a number
print takeLong( cast( T ptr, 0 ) )
print takeTptr( 0 )                      '' a literal binds a pointer (warning 1)
print takeTptr( KN )                     '' ...and so does a named constant
print takeTptr( i1 + 1 )                 '' ...and, measured, a computed value
print takeTptr( @t1 )
print takeTptr( cp1 )                    '' 'operator cast( ) as T ptr'
print takeStr( cp1 )                     '' 'operator cast( ) as string'
print takeC( s1 )                        '' 'constructor( byref as string )'
print takeC( tp )                        '' 'constructor( byval as T ptr )'
print takeBp( dp )                       '' the upcast
print takeB( d1 )
print takeRT( t1 )

sub T.m( )
    print takeRT( this )                 '' 'this' is the object
end sub
t1.m( )
