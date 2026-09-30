'' A private destructor is callable from the type's own members.
type T
	as integer i
	declare sub test( x() as T )
	private:
	declare destructor cdecl( )
end type
destructor T cdecl( )
end destructor
sub T.test( x() as T )
	erase x                                     '' fine: inside a member
	dim as T x2(0 to 1)                         '' fine
end sub
dim as T y(0 to 1)                              '' refused: outside
