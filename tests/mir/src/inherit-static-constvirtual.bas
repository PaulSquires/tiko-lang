'' A STATIC MEMBER CALLED THROUGH THE DERIVED TYPE'S NAME. The member lookup searched
'' the named type's own scope only, so nothing was bound, the walk fell back to
'' resolving 'Child' itself -- a SYM_UDT -- and the diagnostic was "'child' is a type,
'' not a procedure". fbc compiles it and emits '_ZN6PARENT3FOOEv(  );', the same call it
'' emits for 'Parent.foo( )', and prints foo twice.
type Parent extends Object
	declare static sub foo( )
end type

type Child extends Parent
end type

sub Parent.foo( )
	print "foo"
end sub

Parent.foo( )
Child.foo( )

'' 'const virtual' IS ONE DECLARATION. The routing that sends a leading modifier to the
'' procedure parser peeked a SINGLE token, saw 'virtual', fell through to the constant
'' parser and reported "'virtual' has no type" -- and the desync then took the NEXT
'' definition with it, which is where the decline landed. fbc mangles it _ZNK1A3S07Ev
'' and puts it in the vtable.
type A extends Object
	declare const virtual sub s07( )
	declare const virtual function f07( ) as integer
	declare function g( ) as integer
end type

const virtual sub A.s07( )
	print "s07"
end sub

const virtual function A.f07( ) as integer
	return 7
end function

function A.g( ) as integer
	function = 1
end function

dim as A obj
obj.s07( )
print obj.f07( ), obj.g( )
