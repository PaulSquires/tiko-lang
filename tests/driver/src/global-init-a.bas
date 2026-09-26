'' Module one of the pair. Both modules 'dim shared' a UDT that holds a string, so
'' both need _GLOBAL__I and _GLOBAL__D -- and both define those two names. They must
'' be module-local, as fbc emits them, or the link fails on a duplicate symbol.
type T
    s as string
end type

dim shared ga as T
declare sub fromb( )

ga.s = "a"
print ga.s
fromb( )
