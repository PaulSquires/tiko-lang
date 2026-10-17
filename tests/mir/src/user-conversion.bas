'' A USER-DEFINED CONVERSION at a call argument, and at an assignment.
''
'' Both halves were SILENT MISCOMPILES -- lowered, verified, and counted as statements
'' successfully compiled.
''
'' 'f( 1122 )' where the parameter is a UDT with 'declare constructor( byval n as
'' integer )' passed the raw integer straight to the callee: 'call void F( 1122 )', a
'' number where an object belongs. Measured, fbc builds a temporary, calls the conversion
'' constructor into it and passes THAT -- by value when the type has no destructor, by
'' address when it has one, and the temporary dies at the end of the statement.
''
'' 'dim as integer a = q' over a type declaring only 'operator cast( ) as integer' loaded
'' the AGGREGATE and sign-extended it -- the object's first eight bytes reinterpreted as
'' the number. fbc calls the operator and stores its result. The STRING half of the same
'' thing already worked, which is why this went unnoticed.
''
'' The third half is OVERLOAD RESOLUTION: ConversionCost takes only a TypeContext, so it
'' can look up neither a constructor nor a cast operator, and both shapes were not viable
'' for ANY candidate. That was not a diagnostic either -- the call bound to nothing, came
'' out untyped, and whatever consumed it declined.
''
'' The new rank sits above every standard conversion and below CONV_NONE, and the
'' standard conversion that FOLLOWS the user one is added rather than swallowed: measured,
'' offered 'h( integer )' and 'h( double )' against a UDT that casts to integer, fbc picks
'' the DOUBLE overload.
type Conv
    as long i
    declare constructor( byval n as long )
    declare destructor( )
end type

constructor Conv( byval n as long )
    this.i = n
end constructor

destructor Conv( )
end destructor

type Plain
    as long i
    declare constructor( byval n as long )
end type

constructor Plain( byval n as long )
    this.i = n
end constructor

type Casts
    as long n
    declare operator cast( ) as long
end type

operator Casts.cast( ) as long
    return this.n
end operator

sub takesConv( byval x as Conv )
    print x.i
end sub

sub takesPlain( byval x as Plain )
    print x.i
end sub

'' DOUBLE, not LONG: in an overload set a cast to the parameter's own type is no match
'' (fbc's 99 for 'long'), and a converting one reaches it (structpick.tiko NumCastArgPick).
function wants overload( byval i as double ) as long
    return i
end function

function wants overload( byval s as string ) as long
    return len( s )
end function

sub s1( )
    takesConv( 1122 )
    takesPlain( 7 )

    dim as Casts q
    q.n = 5
    dim as long a = q
    dim as long b
    b = q
    dim as long w = wants( q )
    print a, b, w
end sub

s1( )
