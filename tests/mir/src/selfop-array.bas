'' A self-operator and a constructor that take a BYDESC ARRAY, called with a bare
'' array -- the shape structs/udt-array-ops-1.bas is built from.
type T
    myarray(any) as integer
    declare constructor()
    declare constructor( array() as integer )
    declare operator +=( array() as integer )
end type

constructor T()
end constructor

constructor T( array() as integer )
    redim myarray( lbound(array) to ubound(array) )
end constructor

operator T.+=( array() as integer )
    for i as integer = lbound(array) to ubound(array)
        myarray(i) += array(i)
    next
end operator

dim a( 0 to 9 ) as integer
dim x as T
x += a()
dim y as T ptr = new T( a() )
delete y
