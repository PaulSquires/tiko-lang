'' 'base( n )' inside a constructor IS THE BASE-CLASS CONSTRUCTOR CALL.
''
'' 'extends P' is modelled as a FIELD NAMED 'base' at offset 0, which is what makes
'' this ordinary: the receiver is that field's address and the type to construct is
'' that field's type. 'base.i' and 'base.M( )' already went through the member path
'' for the same reason; only the constructor form had nowhere to go.
''
'' AND IT REPLACES THE IMPLICIT DEFAULT BASE CONSTRUCTION. Measured: fbc's C for a
'' constructor that writes one contains the chosen base constructor and nothing else
'' for the base. Emitting both ran the base constructor TWICE over the same storage.
type P
    as integer i
    declare constructor( )
    declare constructor( byval n as integer )
    declare constructor( byval d as double )
end type

constructor P( )
    this.i = -1
end constructor

constructor P( byval n as integer )
    this.i = n
end constructor

constructor P( byval d as double )
    this.i = cint( d )
end constructor

type C_ extends P
    as integer j
    declare constructor( byval n as integer )
    declare constructor( byval d as double, byval n as integer )
end type

'' The overload is chosen from the ARGUMENT TYPES, like any other constructor call.
constructor C_( byval n as integer )
    base( n )
    this.j = n + 1
end constructor

constructor C_( byval d as double, byval n as integer )
    base( d )
    this.j = n
end constructor

'' A constructor that writes no 'base( )' still gets the implicit default one.
type D_ extends P
    declare constructor( )
end type

constructor D_( )
    this.i += 1
end constructor

dim a as C_ = C_( 3 )
dim b as C_ = C_( 1.5, 2 )
dim d as D_
