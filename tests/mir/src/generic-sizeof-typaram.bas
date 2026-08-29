'' 'sizeof( T )' OVER A GENERIC TYPE PARAMETER, in the three positions the corpus and
'' the shipped headers write it.
''
'' 'sizeof( T )' parses T as an EXPRESSION -- an N_IDENT -- not as a type reference, so
'' ResolveTypeRef's substitution never saw it and the node stayed untyped. All three
'' declined, and fb/comptr.bi's ComHeapPtr.Alloc is written as
'' 'cptr( T ptr, CoTaskMemAlloc( count * sizeof( T ) ) )', so the whole allocation
'' produced nothing.
''
'' Measured: fbc folds it to a constant and strength-reduces the multiply --
'' 'fb_PrintULongint( 0, N$1 << (2ull & 63ll), 1 )' for 'n * sizeof( T )' over LONG.
type Holder( of T )
    p as T ptr
    declare sub B1( byval n as uinteger )
    declare sub B2( byval n as uinteger )
end type

sub Holder( of T ).B1( byval n as uinteger )
    dim as uinteger k = sizeof( T )
    print k
end sub

sub Holder( of T ).B2( byval n as uinteger )
    print n * sizeof( T )
end sub

function SzOf( of T )( ) as uinteger
    return sizeof( T )
end function

dim h as Holder( of long )
h.B1( 4 )
h.B2( 4 )
print SzOf( of double )( )
