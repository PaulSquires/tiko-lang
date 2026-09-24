'' A SPAWN ARGUMENT IS CONVERTED THE WAY A CALL ARGUMENT IS -- see spawn-conv-arg.test.
#include once "fb/sync.bi"
using FB

'' A converting constructor on an ordinary type: was TKO0738.
type Counted
	as long ptr n
	declare constructor( )
	declare constructor( byref rhs as Counted )
	declare destructor( )
	declare operator let( byref rhs as Counted )
end type
constructor Counted( ) : n = callocate( sizeof( long ) ) : *n = 1 : end constructor
constructor Counted( byref rhs as Counted ) : n = rhs.n : *n += 1 : end constructor
destructor Counted( ) : *n -= 1 : end destructor
operator Counted.let( byref rhs as Counted ) : *rhs.n += 1 : *n -= 1 : n = rhs.n : end operator

type View
	as Counted c
	declare constructor( byref src as Counted )
end type
constructor View( byref src as Counted ) : this.c = src : end constructor

sub Use( byval v as View )
end sub

'' A directional channel built from a Channel: was a bitwise copy, and the frame's
'' delete then freed the caller's channel.
sub Produce( byval c as SendChan( of long ) )
	c.Send( 7 )
	c.Close( )
end sub

sub Main( )
	dim src as Counted
	spawn Use( src )
	dim ch as Channel( of long ) = Channel( of long )( 4 )
	spawn Produce( ch )
end sub
Main( )
