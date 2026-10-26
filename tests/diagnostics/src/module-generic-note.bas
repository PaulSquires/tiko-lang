'' An error inside a std generic's body, instantiated here: each TKO0632 in map.tiko gets the
'' note 'in instantiation of map( of cell, ustring )' at line 11, and is reported once
'' (by-example BUG-generics-1). A Map key needs a hash; Cell has only '='.
#import "std/containers"
type Cell
    as long row, col
end type
operator = ( byref a as Cell, byref b as Cell ) as boolean
    return ( a.row = b.row ) andalso ( a.col = b.col )
end operator
dim terrain as containers.Map( of Cell, ustring )
