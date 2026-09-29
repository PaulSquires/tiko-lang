'' A bare type( ) for a byref parameter of an incomplete type or 'any' -- fbc's error 71 on
'' the refused lines.
type fw as forward
declare sub f1( byref x as fw )
declare sub f2( byref x as any )
declare sub f3( byval x as any ptr )
f1( type( 0 ) )                            '' 71
f2( type( 0 ) )                            '' 71
f3( type( 0 ) )                            '' fine
