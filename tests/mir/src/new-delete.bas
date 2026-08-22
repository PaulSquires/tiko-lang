'' 'new T' AND 'delete p'.
''
'' NEW is classed as an OPERATOR in the keyword table, so Primary had no case for it and
'' it fell through to the identifier path: 'p = new T' parsed as the plain identifier
'' 'new' with the TYPE DROPPED ENTIRELY. Every allocation in the corpus lowered to
'' nothing.
''
'' Measured, and none of it is guessable from the C++ these operators are named after:
''
''   - THE ALLOCATOR IS ALWAYS libc calloc( bytes, 1 ) -- never malloc, never a runtime
''     helper -- so every allocation is ZERO-FILLED BY CONSTRUCTION. That is what lets
''     'new string' work with NO constructor call at all: the zeroing IS the FBSTRING's
''     initialisation. The second argument is the element count and is always 1; the
''     whole size goes in the first, not the other way round.
''   - THE NULL GUARD IS INLINE, at the call site, around the construction. The runtime
''     never sees a null.
''   - 'delete' of a 'string ptr' is fb_StrDelete THEN free. There is no UDT destructor
''     to find, and without the first call the descriptor's own allocation leaks.
''   - Constructor arguments follow the receiver: 'new C( x )' is '_ZN1CC1Ei( TMP, X )',
''     and they are evaluated where the 'new' is WRITTEN, not inside the guarded arm.
''
'' NOT DONE, and declining rather than half-done: the ARRAY form. Its cookie is keyed on
'' "the type has a DESTRUCTOR", not on "this is an array" -- 'new C[n]' where C has a
'' constructor but no destructor allocates no cookie at all -- so the layout of what
'' 'new T[n]' returns depends on a property of T that is invisible at the delete site.

type T
    a as long
end type
type C
    a as long
    declare constructor( )
    declare constructor( byval x as long )
    declare destructor( )
end type
constructor C( )
end constructor
constructor C( byval x as long )
    this.a = x
end constructor
destructor C( )
end destructor
dim shared as T ptr p
dim shared as C ptr q
dim shared as string ptr s
dim shared as long g
sub P( )
    p = new T
    delete p
    q = new C
    delete q
    q = new C( g )
    delete q
    s = new string
    delete s
end sub
