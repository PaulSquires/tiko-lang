'' A TUPLE WHOSE ELEMENT TYPE CONTAINS A DYNAMIC ARRAY.
''
'' The field walk that flattens a UDT literal into leaves refused a dynamic-array field
'' outright, and refusing one field refused the whole flatten -- so every type with a
'' dynamic array anywhere inside it declined. 'FB.Array( of T )' has one, which is how
'' this reached the corpus: 'return (kv.key, kv.value)' out of a Map's tuple view is the
'' shape, and it declined for a Map whose value type was a container.
''
'' A dynamic array IS ONE LEAF -- its descriptor -- and not a run of them. Measured: fbc
'' copies such an element with a single whole-object memcpy of the field, the descriptor
'' and not the data, which is what the aggregate store this leaf attracts already emits.
type Dyn
    as long items( any )
    as long num
end type

function f( ) as (long, Dyn)
    dim as long k = 1
    dim as Dyn d
    d.num = 9
    return (k, d)
end function

sub s1( )
    dim as (long, Dyn) t = f( )
    print t._1, t._2.num
end sub

s1( )
