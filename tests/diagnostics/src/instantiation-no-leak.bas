'' After instantiations -- including one that fails -- an error in ORDINARY code must
'' carry no instantiation note: a frame left active would attach one to everything.
type Box( of T )
    declare function Same( byval a as T, byval b as T ) as boolean
    as T v
end type
function Box( of T ).Same( byval a as T, byval b as T ) as boolean
    return a = b
end function
type Opaque_
    as long x
end type
dim good as Box( of long )
dim bad as Box( of Opaque_ )
dim as Opaque_ p, q
if p > q then print "never"
