'' A field of a const object, however the object is reached -- fbc's error 119 on the
'' refused lines.
type UDT
    i as integer
    a(3) as integer
    q as UDT ptr
end type
dim x as UDT
dim cx as const UDT = ( 1 )
dim pcx as const UDT ptr = @x
cast( const UDT, x ).i = 5       '' 119
pcx->i = 5                       '' 119
(*pcx).i = 5                     '' 119
cx.a( 1 ) = 5                    '' 119
cast( UDT, x ).i = 5             '' fine
cx.q->i = 5                      '' fine: the pointee is not const
x.i = 5                          '' fine
