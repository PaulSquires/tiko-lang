type Obj
    k as integer
    declare constructor( byval k as integer )
end type
constructor Obj( byval k as integer ) : this.k = k : end constructor
dim p1 as Obj ptr = new Obj
dim p2 as Obj ptr = new Obj[2] { any }
dim p3 as Obj ptr = new Obj( 4 )
dim p4 as Obj ptr = new Obj[2]
