' TEST_MODE : COMPILE_AND_RUN_OK

'' A PROCEDURE-POINTER as a generic type argument.
''
'' The bug this pins was a USE-AFTER-FREE, which is why it is worth a file of
'' its own rather than a line in another one.
''
'' A procptr type is described by an anonymous PROC symbol, and symbAddProcPtr
'' gives that symbol the lifetime of the scope it was spelled in -- correct for
'' an ordinary DIM, because a procptr spelled inside a procedure may name that
'' procedure's locals in its own signature.
''
'' A TYPE ARGUMENT outlives its call site: the instantiation's TYPEDEF keeps
'' pointing at the symbol, and the instantiation's BODY is not replayed until
'' the next module-level statement boundary -- by which time the owning scope
'' has closed and the symbol node has been recycled.  The parameter then came
'' out with the type of whatever had reused it: 'unknown type name label$6' from
'' the C backend, or a call through a procptr-to-SUB (error 17, then a segfault)
'' when the slot held a proc.
''
'' Because it is a use-after-free it also SOMETIMES WORKED -- the identical
'' program with one less generic in front of it left the node unrecycled and
'' compiled and ran correctly.  So the cases below deliberately vary how much
'' symbol churn happens between the instantiation and the body replay, and
'' every one of them CALLS through the pointer, which is what dereferences the
'' recycled type.

#include once "fb/array.bi"
using FB

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

function Less( byval x as long, byval y as long ) as boolean
	return x < y
end function

function Greater( byval x as long, byval y as long ) as boolean
	return x > y
end function

sub Bump( byref n as long )
	n += 1
end sub

'' The generic that receives the pointer.  It CALLS c, which is what the broken
'' binding could not survive.
function Apply2( of T, C )( byval a as T, byval b as T, byref c as C ) as boolean
	return c( a, b )
end function

sub ApplySub( of T, C )( byref a as T, byref c as C )
	c( a )
end sub

'' ============================================ from inside a generic PROCEDURE

'' The original failure: the procptr type is spelled inside a generic body, so
'' its symbol belongs to that body's scope, and the instantiation it feeds is
'' not replayed until that scope is long gone.
function FromGeneric( of T )( byval x as T ) as boolean
	dim as function( byval as long, byval as long ) as boolean cmp = @Less
	return Apply2( 1, 2, cmp )
end function

'' The same, with a lambda rather than '@proc'.
function FromGenericLambda( of T )( byval x as T ) as boolean
	dim as function( byval as long, byval as long ) as boolean cmp = _
		function( byval a as long, byval b as long ) as boolean
			return a > b
		end function
	return Apply2( 1, 2, cmp )
end function

'' A SUB pointer, whose proto has a VOID result -- the shape that produced the
'' error 17 rather than the bad type name.
sub FromGenericSub( of T )( byref n as T )
	dim as sub( byref as long ) f = @Bump
	ApplySub( n, f )
end sub

'' Two different procptr types from one generic body, so the second cannot pass
'' by inheriting the first's symbol.
function TwoPointers( of T )( byval x as T ) as long
	dim as function( byval as long, byval as long ) as boolean lt = @Less
	dim as function( byval as long, byval as long ) as boolean gt = @Greater
	dim as long score = 0
	if( Apply2( 1, 2, lt ) ) then
		score += 1
	end if
	if( Apply2( 1, 2, gt ) ) then
		score += 2
	end if
	return score
end function

'' Two levels of generic nesting before the pointer is used.
function Deeper( of T )( byval x as T ) as boolean
	return FromGeneric( x )
end function

'' A generic TYPE's member spelling the procptr, rather than a generic proc.
type Runner( of T )
	as T seed
	declare function Run( ) as boolean
end type

function Runner( of T ).Run( ) as boolean
	dim as function( byval as long, byval as long ) as boolean cmp = @Less
	return Apply2( 1, 2, cmp )
end function

'' A procptr as an EXPLICIT type argument spelled inside a generic body.
function ExplicitArg( of T )( byval x as T ) as boolean
	dim as function( byval as long, byval as long ) as boolean cmp = @Less
	return Apply2( of long, function( byval as long, byval as long ) as boolean )( 1, 2, cmp )
end function

'' A generic TYPE instantiated with a procptr type argument, from inside a
'' generic body.  This path always worked; it is here so a future change that
'' breaks it is caught.
type Slot( of C )
	as C fn
end type

function ViaSlot( of T )( byval x as T ) as boolean
	dim as Slot( of function( byval as long, byval as long ) as boolean ) s
	s.fn = @Less
	return s.fn( 1, 2 )
end function

'' ==================================================================== checks

'' From module level first -- the case that always worked.
scope
	dim as function( byval as long, byval as long ) as boolean cmp = @Less
	assert_( Apply2( 1, 2, cmp ) )
	assert_( Apply2( 2, 1, cmp ) = false )
end scope

'' From a plain procedure.
function FromPlain( byval x as long ) as boolean
	dim as function( byval as long, byval as long ) as boolean cmp = @Less
	return Apply2( 1, 2, cmp )
end function

assert_( FromPlain( 0 ) )

'' From inside generics -- every one of these failed before the fix.
assert_( FromGeneric( 0 ) )
assert_( FromGenericLambda( 0 ) = false )     '' 1 > 2 is false
assert_( TwoPointers( 0 ) = 1 )               '' lt yes, gt no
assert_( Deeper( 0 ) )
assert_( ExplicitArg( 0 ) )
assert_( ViaSlot( 0 ) )

scope
	dim as long n = 41
	FromGenericSub( n )
	assert_( n = 42 )
end scope

scope
	dim as Runner( of long ) r
	r.seed = 3
	assert_( r.Run( ) )
end scope

'' Two instantiations of the same generic over DIFFERENT procptr types, so the
'' cache key has to tell them apart after the hoist.
scope
	dim as function( byval as long, byval as long ) as boolean lt = @Less
	dim as sub( byref as long ) bp = @Bump
	assert_( Apply2( 1, 2, lt ) )
	dim as long n = 0
	ApplySub( n, bp )
	assert_( n = 1 )
end scope

'' The same procptr type reached from two different places must be ONE
'' instantiation, not two -- the hoist re-interns by mangled signature, and if
'' it did not, these would be distinct types.
assert_( FromGeneric( 0 ) )
assert_( FromGeneric( 0.5 ) )                 '' different T, same C

'' Sorting is the real client: fb/sort.bi's Sort( ) is exactly this pattern --
'' a generic sub building a procptr and handing it to another generic.
scope
	dim as Array( of long ) a
	a.Push( 3 ) : a.Push( 1 ) : a.Push( 2 )
	'' not named 'less': FreeBASIC identifiers are case-insensitive, so it
	'' would collide with the module-level Less( ) above
	dim as function( byref as long, byref as long ) as boolean lessFn = _
		function( byref x as long, byref y as long ) as boolean
			return x < y
		end function
	assert_( lessFn( a[ 1 ], a[ 0 ] ) )
end scope

print "generic-procptr-typearg: ok"
