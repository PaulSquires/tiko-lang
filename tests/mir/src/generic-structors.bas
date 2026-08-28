'' A GENERIC'S USER-DECLARED CONSTRUCTOR AND DESTRUCTOR NEVER RAN. Not a decline -- it
'' lowered and it verified. The member-instantiation loop filters by ownerName, and a
'' structor is written 'constructor G( of T )( )' with NO DOT, so the parser records no
'' owner and every structor was thrown away. An ordinary member is
'' 'function G( of T ).Get( )', HAS the dot, and passed -- which is why member functions
'' instantiated and structors did not.
''
'' That was ComPtr's and SharedPtr's refcounting, LinkedList's teardown and Channel's
'' reference count, none of them running.
''
'' Measured against fbc, which emits for the three declarations below:
''
''     _ZN1GIiEC1Ev( &A$0 );
''     _ZN1GIiEC1ERS0_( &B$0, &A$0 );
''     _ZN1GIiEC1ERS0_( &C$0, &A$0 );
''     _ZN1GIiED1Ev( &C$0 ); _ZN1GIiED1Ev( &B$0 ); _ZN1GIiED1Ev( &A$0 );
type G( of T )
    dim as T v
    declare constructor( )
    declare constructor( byref rhs as G( of T ) )
    declare destructor( )
end type

constructor G( of T )( )
    v = 1
end constructor

constructor G( of T )( byref rhs as G( of T ) )
    v = rhs.v + 100
end constructor

destructor G( of T )( )
end destructor

'' ...and an ordinary member, which always worked, so the two paths are exercised side
'' by side.
type H( of T )
    dim as T v
    declare function Get( ) as T
end type

function H( of T ).Get( ) as T
    return v
end function

dim as G( of long ) a
var b = a
dim as G( of long ) c = a
print a.v, b.v, c.v

dim as H( of long ) h
h.v = 9
print h.Get( )

'' ...AND CONSTRUCTING ONE WITH ARGUMENTS. The callee spells the TEMPLATE, 'K', while
'' the declared type is the INSTANTIATION, so a name comparison alone said no and the
'' whole thing fell through to the copy path -- a temporary constructed and copied out,
'' with the temporary's own destructor never run. Measured, fbc constructs in place:
''
''     _ZN1KIiEC1Ei( &Q$0, 7 );
''     _ZN1KIiED1Ev( &Q$0 );
type K( of T )
    dim as T v
    declare constructor( )
    declare constructor( byval n as T )
    declare destructor( )
end type

constructor K( of T )( )
    v = 5
end constructor

constructor K( of T )( byval n as T )
    v = n
end constructor

destructor K( of T )( )
end destructor

dim as K( of long ) p
dim as K( of long ) q = K( of long )( 7 )
print p.v, q.v
