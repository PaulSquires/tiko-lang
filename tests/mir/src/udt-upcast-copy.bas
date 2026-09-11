'' AN UPCAST COPIES THE BASE SUBOBJECT, NOT THE WHOLE DERIVED VALUE.
''
'' 'dim as parent p = c' over a child loaded all sixteen bytes and stored them into the
'' eight-byte parent slot --
''
''     %t68 = load [16 x i8], ptr %s9
''     store [8 x i8] %t68, ptr %s8
''
'' -- which clang refuses outright, so nothing built. The base subobject is at offset 0
'' (that is what EXTENDS is: a field named 'base' declared first), so the copy is the
'' DESTINATION's size taken from the source's ADDRESS.
''
'' FOUR SPELLINGS NEEDED IT and each is a different path: an initialiser, a plain byval
'' argument, an explicit cast, and the byval COPY a type with a destructor gets.
''
'' AND THE OTHER DIRECTION: 'cast( parent, d ) = p' writes INTO the base subobject, a
'' 16-byte value through a 48-byte slot, and the emitter took the slot's size for the
'' store. The value's width is the write.
type P1
	as integer a, b
end type

type C1 extends P1
	as integer c, d
end type

sub Take( byval p as P1, byval expect as integer )
	if p.a <> expect then print "BAD arg"; p.a; " want"; expect
end sub

dim as C1 c
c.a = 1 : c.b = 2 : c.c = 3 : c.d = 4

'' an initialiser
dim as P1 p1 = c
print p1.a; p1.b

'' a plain byval argument, and an explicit cast
Take( c, 1 )
Take( cast( P1, c ), 1 )

'' a type literal of the DERIVED type initialising the BASE
dim as P1 p2 = type<C1>( 7, 8, 9, 10 )
print p2.a; p2.b

'' ...and the other direction: a store INTO the base subobject
dim as C1 d
d.c = 30 : d.d = 40
dim as P1 src
src.a = 11 : src.b = 12
cast( P1, d ) = src
print d.a; d.b; d.c; d.d

'' a BYREF UDT parameter reaching base( ) -- the argument is an ADDRESS, and the
'' parameter's own type does not say so because a reference is transparent.
type C2 extends P1
	as integer e
	declare constructor( byref p as P1, byval e0 as integer )
end type

constructor C2( byref p as P1, byval e0 as integer )
	base( p )
	this.e = e0
end constructor

dim as C2 made = C2( src, 99 )
print made.a; made.b; made.e
