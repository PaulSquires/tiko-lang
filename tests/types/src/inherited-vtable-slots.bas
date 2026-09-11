'' A DERIVED TYPE'S INHERITED SLOTS ARE COPIED, and copying them pushed elements of a
'' vector INTO ITSELF:
''
''     store.slots.Push( store.slots[ b->first + i ] )
''
'' The argument is a REFERENCE into the vector, and the Push that reallocates it leaves
'' that reference dangling BEFORE the copy is made. The slot that landed held whatever
'' the freed block did -- and it looked like a real entry, so the table came out with a
'' PROCEDURE in it that mangled to the empty string: 'ptr @""', which clang reports as
'' 'use of undefined value'.
''
'' THREE INHERITED AND FIVE OWN is the smallest shape that shows it -- fb/comptr.bi's
'' ComUnknown and com/comptr-companions' IShellItem_. Every slot here is abstract, so
'' every entry in the emitted table must be null.
type Base_ extends object
	declare abstract function A( ) as long
	declare abstract function B( ) as long
	declare abstract function C( ) as long
end type

type Derived_ extends Base_
	declare abstract function D( ) as long
	declare abstract function E( ) as long
	declare abstract function F( ) as long
	declare abstract function G( ) as long
	declare abstract function H( ) as long
end type

'' ...and a concrete leaf, so the inherited slots are FILLED rather than only copied.
type Leaf_ extends Base_
	declare function A( ) as long
	declare function B( ) as long
	declare function C( ) as long
end type

function Leaf_.A( ) as long
	return 1
end function
function Leaf_.B( ) as long
	return 2
end function
function Leaf_.C( ) as long
	return 3
end function

dim as Leaf_ l
dim as Base_ ptr p = @l
print p->A( ); p->B( ); p->C( )
