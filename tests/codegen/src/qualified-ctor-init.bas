'' 'dim as N.T x = N.T( args )' builds x IN PLACE, as the unqualified spelling does: the
'' constructor's @this is x's own address, and every constructor has its destructor. tiko
'' built a QUALIFIED one in a temporary and copied the bytes out -- the temporary never
'' destroyed, x destroyed without having been constructed. An object that hands '@this'
'' to someone else then points them at a dead slot: FB.AsyncSink gives it to its worker
'' thread, and through std/logs's 'logs.AsyncSink( ... )' the program hung.

dim shared as long ctors, dtors
dim shared as any ptr built

namespace N
	type T
		declare constructor( byval n as long )
		declare destructor( )
		as long v
	end type
	constructor T( byval n as long )
		this.v = n
		built = @this
		ctors += 1
	end constructor
	destructor T( )
		dtors += 1
	end destructor
	namespace Inner
		type U
			declare constructor( byval n as long )
			declare destructor( )
			as long v
		end type
		constructor U( byval n as long )
			this.v = n
			built = @this
			ctors += 1
		end constructor
		destructor U( )
			dtors += 1
		end destructor
	end namespace
end namespace

sub InAProc( )
	dim as N.T a = N.T( 1 )
	print "proc qualified in place: "; iif( built = @a, "yes", "no" ); " v="; a.v
	dim as N.Inner.U b = N.Inner.U( 2 )
	print "proc nested in place: "; iif( built = @b, "yes", "no" ); " v="; b.v
	using N
	dim as T c = T( 3 )
	print "proc unqualified in place: "; iif( built = @c, "yes", "no" ); " v="; c.v
end sub

InAProc( )
print "proc ctors="; ctors; " dtors="; dtors

dim as N.T m = N.T( 4 )
print "module qualified in place: "; iif( built = @m, "yes", "no" ); " v="; m.v
