'' A constructor( ) chain call anywhere but first -- fbc's error 169 on the refused lines.
type T
    as integer i
    declare constructor( )
    declare constructor( byval as integer )
    declare constructor( byval as integer, byval as integer )
end type
constructor T( byval i as integer )
    this.i = i
end constructor
constructor T( )
    print "first"
    constructor( 5 )                           '' 169
end constructor
constructor T( byval a as integer, byval b as integer )
    constructor( a )                           '' fine: first
    print b
end constructor
