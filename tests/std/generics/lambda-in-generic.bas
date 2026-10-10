' TEST_MODE : COMPILE_AND_RUN_OK

'' Lambdas and generics in the same body -- the two token-capture passes.
''
'' A generic's body is captured as tokens and replayed; so is a lambda's.  Both
'' passes have to decide whether a SUB|FUNCTION token opens a nested lambda,
'' and before lambdas existed neither had to ask -- procedures cannot nest in
'' FreeBASIC.  Both got it wrong, in opposite directions:
''
''   - hCaptureProcBody counted NOTHING, so a generic FUNCTION containing a
''     lambda ended its capture at the LAMBDA's 'END FUNCTION' and reported
''     error 53 and error 112 against the leftovers.  A generic SUB was
''     unaffected -- its terminator is 'END SUB' -- which is why this survived.
''
''   - hCaptureLambdaBody counted EVERYTHING, so a procedure-pointer
''     declaration inside a lambda body raised the depth and never lowered it:
''     error 351, Unterminated lambda body.
''
'' Both now ask lambdaOpensHere, and this file is every spelling of the keyword
'' that has to be got right.  Each one is a separate scope so that a failure
'' names the case.
#import "std/containers"
using containers
#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

function Ident( byval v as long ) as long
	return v
end function

function Cmp( byval x as long, byval y as long ) as boolean
	return x < y
end function

'' ============================================ a generic FUNCTION with a lambda

'' The original failure. Nothing else about it is unusual.
function WithLambda( of T )( byval x as T ) as T
	dim as function( byval as T ) as T g = _
		function( byval v as T ) as T
			return v + v
		end function
	return g( x )
end function

'' The one-line lambda form spells the same tokens on one line.
function WithOneLineLambda( of T )( byval x as T ) as T
	dim as function( byval as T ) as T g = _
		function( byval v as T ) as T : return v + 1 : end function
	return g( x )
end function

'' A capturing lambda in a generic function: a closure object, not a procptr,
'' and its 'END SUB' is not the generic's.
''
'' The lambda's PARAMETER type is deliberately concrete.  A capturing lambda
'' that names the enclosing generic's T in its own parameter list is a separate
'' and still-open limitation -- see fail-lambda-capture-typaram.bas -- which was
'' invisible until the capture bug above was fixed, because the body never got
'' as far as being replayed.
function WithCapture( of T )( byval x as T ) as T
	dim as long bias = 10
	dim as long total = 0
	ForEach2( x, sub[ byref total, byval bias ]( byval v as long )
		total = v + bias
	end sub )
	return total
end function

sub ForEach2( of T, F )( byval x as T, byref f as F )
	f( x )
end sub

'' Two lambdas in one generic function, and one nested inside the other.
function Nested( of T )( byval x as T ) as T
	dim as function( byval as T ) as T outer_ = _
		function( byval v as T ) as T
			dim as function( byval as T ) as T inner = _
				function( byval w as T ) as T
					return w * 2
				end function
			return inner( v ) + 1
		end function
	return outer_( x )
end function

'' ============================ the keyword WITHOUT opening a block, in a generic

'' 'function = x', the classic return-value assignment. Counted as an opener,
'' this never balances.
function ReturnAssign( of T )( byval x as T ) as T
	function = x + 1
end function

'' A procedure-pointer TYPE. Counted as an opener, this never balances either.
function ProcPtrDecl( of T )( byval x as T ) as T
	dim as function( byval as long ) as long cb = @Ident
	return cb( x )
end function

'' 'exit function' / 'exit sub' name the kind without opening one.
function ExitEarly( of T )( byval x as T ) as T
	if( x > 0 ) then
		function = x
		exit function
	end if
	function = 0
end function

sub ExitEarlySub( of T )( byval x as T, byref out as T )
	out = x
	exit sub
end sub

'' A type in the one position where a type follows '(' rather than AS.
function CastType( of T )( byval x as T ) as T
	dim as any ptr p = @Ident
	dim as function( byval as long ) as long q = _
		cast( function( byval as long ) as long, p )
	return q( x )
end function

'' A procptr type as an explicit generic TYPE ARGUMENT: inside '( of ... )'
'' everything is a type, and nothing local to the keyword can show that.
sub TakeCmp( of T, C )( byval x as T, byref c as C, byref out as boolean )
	out = c( x, x+1 )
end sub

function ExplicitTypeArg( of T )( byval x as T ) as boolean
	dim as function( byval as long, byval as long ) as boolean less = @Cmp
	dim as boolean r = false
	TakeCmp( of T, function( byval as long, byval as long ) as boolean )( x, less, r )
	return r
end function

'' ================================ a procptr declared inside a LAMBDA body

'' The other direction: hCaptureLambdaBody counted this as opening a lambda.
'' Not a generic at all -- it failed in plain code.
scope
	dim as function( byval as long ) as long g = _
		function( byval v as long ) as long
			dim as function( byval as long ) as long h = @Ident
			return h( v ) + 100
		end function
	assert_( g( 5 ) = 105 )
end scope

'' A lambda nested in a lambda, each declaring a procptr.
scope
	dim as function( byval as long ) as long g = _
		function( byval v as long ) as long
			dim as function( byval as long ) as long h = _
				function( byval w as long ) as long
					dim as function( byval as long ) as long k = @Ident
					return k( w ) * 3
				end function
			return h( v ) + 1
		end function
	assert_( g( 4 ) = 13 )
end scope

'' 'exit function' and a procptr type inside a lambda body.
scope
	dim as function( byval as long ) as long g = _
		function( byval v as long ) as long
			dim as function( byval as long ) as long h = @Ident
			if( v < 0 ) then
				function = 0
				exit function
			end if
			function = h( v )
		end function
	assert_( g( 7 ) = 7 )
	assert_( g( -1 ) = 0 )
end scope

'' ============================ the generic terminator is not always END SUB

'' Depth counting must not swallow END OPERATOR / END CONSTRUCTOR /
'' END DESTRUCTOR / END PROPERTY, which are terminators of their own and are
'' never a lambda's.  Every one of them, each with a lambda inside.
type Boxed( of T )
	as T v
	declare constructor( )
	declare constructor( byval n as T )
	declare destructor( )
	declare operator [] ( byval i as long ) byref as T
	declare property doubled( ) as T
	declare property doubled( byval n as T )
end type

dim shared as long boxedDtors

constructor Boxed( of T )( )
	dim as function( ) as T z = _
		function( ) as T
			return 0
		end function
	this.v = z( )
end constructor

constructor Boxed( of T )( byval n as T )
	dim as function( byval as T ) as T id = _
		function( byval x as T ) as T
			return x
		end function
	this.v = id( n )
end constructor

destructor Boxed( of T )( )
	dim as sub( ) bump = _
		sub( )
			boxedDtors += 1
		end sub
	bump( )
end destructor

operator Boxed( of T ).[] ( byval i as long ) byref as T
	dim as function( byval as long ) as long clamp = _
		function( byval k as long ) as long
			if( k < 0 ) then
				return 0
			end if
			return k
		end function
	dim as long unused = clamp( i )
	return this.v
end operator

property Boxed( of T ).doubled( ) as T
	dim as function( byval as T ) as T twice = _
		function( byval x as T ) as T
			return x + x
		end function
	return twice( this.v )
end property

property Boxed( of T ).doubled( byval n as T )
	dim as function( byval as T ) as T half = _
		function( byval x as T ) as T
			return x \ 2
		end function
	this.v = half( n )
end property

'' ================================================================= checks

assert_( WithLambda( 21 ) = 42 )
assert_( WithOneLineLambda( 41 ) = 42 )
assert_( WithCapture( 5 ) = 15 )
assert_( Nested( 3 ) = 7 )

assert_( ReturnAssign( 41 ) = 42 )
assert_( ProcPtrDecl( 9 ) = 9 )
assert_( ExitEarly( 4 ) = 4 )
assert_( ExitEarly( -4 ) = 0 )
assert_( CastType( 8 ) = 8 )
assert_( ExplicitTypeArg( 1 ) )

scope
	dim as long got = 0
	ExitEarlySub( of long )( 12, got )
	assert_( got = 12 )
end scope

scope
	boxedDtors = 0
	scope
		dim as Boxed( of long ) b = Boxed( of long )( 6 )
		assert_( b.v = 6 )
		assert_( b[ 0 ] = 6 )
		assert_( b.doubled = 12 )
		b.doubled = 20
		assert_( b.v = 10 )

		dim as Boxed( of long ) d
		assert_( d.v = 0 )
	end scope
	'' both went out of scope, and the destructor -- whose own body holds a
	'' lambda -- ran for each
	assert_( boxedDtors >= 2 )
end scope

'' A generic function containing a lambda, over two instantiations, to confirm
'' the captured tokens replay more than once.
assert_( WithLambda( of long )( 5 ) = 10 )
assert_( WithLambda( of double )( 1.5 ) = 3.0 )

print "lambda-in-generic: ok"
