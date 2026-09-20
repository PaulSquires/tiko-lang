'' A GENERIC INSTANTIATED DIRECTLY IN A TYPE FIELD.
''
'' Both field spellings, because they are two different parser paths: 'b as Box( of
'' long )' parses the NAME first and then the type, while 'dim as Box( of double ) d'
'' parses the type first. fbc-modern instantiates only the second -- in the first its
'' 'hFieldId' hands back a pointer into ONE static buffer, and instantiating the
'' generic re-parses its body through the same function, so the field is added under
'' whatever name that re-parse left behind ('idx', out of ArrayIterator, measured
'' 2026-09-19). tiko-lang has no such buffer: TypeRef consumes '( of ... )' itself,
'' one token of look-ahead, and the array-bounds position is untouched.
''
'' THE LAYOUT IS fbc's, measured on the all-'dim' spelling it does accept:
''   sizeof( Holder ) = 40, offsets 0, 8, 16, 32
''   sizeof( Box( of long ) ) = 4, sizeof( Pair( of long, double ) ) = 16

type Box( of T )
    as T value
end type

type Pair( of K, V )
    as K k
    as V v
end type

type Holder
    b as Box( of long )                     '' name first
    dim as Box( of double ) d               '' type first
    pr as Pair( of long, double )           '' two arguments, name first
    n as long
end type

'' A GENERIC FIELD INSIDE A GENERIC, and a field of the SAME generic at another
'' argument list: the instantiation cache is keyed by (generic, arguments), so these
'' are three distinct types and one of them is reached twice.
type Cell( of T )
    inner as Box( of T )
    tag as long
end type

sub P( )
    dim as Holder h
    h.b.value = 1
    h.d.value = 2.5
    h.pr.k = 3
    h.pr.v = 4.5
    h.n = 5

    dim as Cell( of long ) c
    c.inner.value = 6
    c.tag = 7

    '' CACHED: 'Box( of long )' here and the one inside Holder are the same type.
    dim as Box( of long ) b2
    b2 = h.b
end sub
