'' CONST AND STATIC DESCRIBE A THIS, so a free procedure may have neither -- fbc errors
'' 259 and 258. 'operator new' and 'operator delete' are implicitly STATIC and so have no
'' THIS either, which makes CONST on one error 234. And a BITFIELD cannot be wider than
'' its type (error 78) -- measured at the boundary for each width: ':8 as byte' is
'' accepted and ':9' is not, ':16 as short' yes and ':17' no, ':32 as long' yes and ':33'
'' no.
type Good
    okByte : 8 as byte
    okShort : 16 as short
    okLong : 32 as long
    declare const sub m( )
    declare static sub s( )
end type

type Bad
    badByte : 9 as byte
    badShort : 17 as short
    badLong : 33 as long
    declare const operator new( byval n as integer ) as Bad ptr
    declare const operator delete( byval p as any ptr )
end type

const sub looseConst( )
end sub

static sub looseStatic( )
end sub
