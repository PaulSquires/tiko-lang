'' NINE SMALL RULES, each measured against fbc: an empty ALIAS on a type or enum (error
'' 304) and an empty LIB on an extern block (305), a type suffix on a field name (17), an
'' override whose bydesc parameter has a different rank (231, or 223 with 'override'),
'' VIRTUAL or ABSTRACT on a definition whose declaration has neither (219, 220), a string
'' selector on ON ... GOTO (20), 'ubound' of an
'' array inside its own '...' initializer (58), and a namespace member that does not
'' exist (8). The accepted lines beside them compile.
type T1 alias ""
    i as integer
end type
type T2 alias "t2"
    i as integer
end type
enum E1 alias ""
    N1
end enum
extern "c" lib ""
end extern
extern "c" lib "m"
end extern
type T3
    i$ as integer
    as integer j$
    k as integer
end type
type A1 extends object
    declare virtual sub f( ( ) as integer )
    declare virtual sub g( ( any ) as integer )
    declare virtual sub h( ( any ) as integer )
end type
type B1 extends A1
    declare sub f( ( any ) as integer ) override
    declare sub g( ( any, any ) as integer ) override
    declare sub h( ( any ) as integer ) override
end type
type U1 extends object
    dummy as integer
    declare sub f( )
    declare sub g( )
    declare virtual sub h( )
end type
virtual sub U1.f( )
end sub
abstract sub U1.g( )
end sub
virtual sub U1.h( )
end sub
dim s as string
dim d as double
on s goto lbl
on d goto lbl
lbl:
dim arr1(0 to ...) as integer = { ubound( arr1 ) }
dim arr2(0 to ...) as integer = { 1, lbound( arr2 ) }
dim arr3(0 to 2) as integer = { 1, ubound( arr3 ), 3 }
namespace ns
    dim shared inside as integer
end namespace
print ns.inside
print ns.outside
