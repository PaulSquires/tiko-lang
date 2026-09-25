'' A generic TYPE's field naming a type nothing declares -- fbc's error 14 when the generic
'' is instantiated (fbc-modern 1.20, reported on the generic's own line). tiko points at
'' the fields, lines 6 and 10. Unused, line 12's generic is accepted by both.
type Box( of T )
    as T value
    as Wdiget oops
end type
type PBox( of T )
    as T value
    as Gadgit ptr p
end type
type Unused( of T )
    as Nowhere n
end type
dim b as Box( of long )
dim pb as PBox( of long )
