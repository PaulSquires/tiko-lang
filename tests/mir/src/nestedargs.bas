declare function G( byval x as long ) as long
declare sub F( byval a as long, byval b as long )
F( G( 7 ), 9 )
