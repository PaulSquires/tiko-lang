'' A shared variable initialised, at start-up, from one declared later -- which would not
'' be constructed yet. One initialised from an earlier one is fine.
#module "later"
type T
    v as long
    declare constructor( byval x as long )
end type
constructor T( byval x as long )
    v = x
end constructor
dim shared first_ as T = T( 1 )
dim shared a as T = T( b.v )
dim shared b as T = T( 3 )
dim shared fine as T = T( first_.v )
