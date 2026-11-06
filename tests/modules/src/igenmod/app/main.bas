'' An importer instantiates the published generic interface, implements one instance on a
'' type of its own, and converts an instance of the published generic class to another.
#import "coll/getters"
type Seven
    implements getters.IGet( of long )
    as long pad
    declare function Get( ) as long implements getters.IGet( of long ).Get
end type
function Seven.Get( ) as long
    return 7
end function
dim as Seven s
dim as getters.IGet( of long ) g = @s
dim as getters.Cell( of string ) c
c.v = "cell"
dim as getters.IGet( of string ) h = @c
print g.Get( ), h.Get( )
