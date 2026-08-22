'' INSTANTIATING A GENERIC TYPE.
''
'' Monomorphisation, the same thing fbc does: one concrete UDT per (generic, argument
'' list), built in the global scope and cached under a structural key.
''
'' Before this, the parser SKIPPED both the parameter list and the argument list, so
'' every instantiation of one generic was the same type -- a fieldless UDT of SIZE
'' ZERO. 'dim b as Box( of long )' reserved nothing and 'b.value = 1' had nowhere to
'' store.
''
'' The sizes below are the point, and each one is what fbc's own
'' __FB_STATIC_ASSERT( sizeof( struct $3BoxIiE ) == 4 ) says.

type Box( of T )
    as T value
end type

type Pair( of K, V )
    as K k
    as V v
end type

sub P( )
    dim b as Box( of long )              '' 4
    dim d as Box( of double )            '' 8
    dim n as Box( of Box( of long ) )    '' 4 -- nested, and the argument resolves first
    dim pr as Pair( of long, double )    '' 16

    b.value = 1
    d.value = 2.5
    n.value.value = 3
    pr.k = 4
    pr.v = 5.5

    '' CACHED: two spellings of one instantiation must be the SAME type, or this
    '' assignment would not typecheck.
    dim b2 as Box( of long )
    b2 = b
end sub
