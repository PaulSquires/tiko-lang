'' fbc 227. A TYPE THAT DECLARES NO DESTRUCTOR GETS AN IMPLICIT ONE, and an implicit one
'' has the DEFAULT calling convention -- so it cannot override a base destructor
'' declared 'pascal'.
type A extends object
    declare virtual destructor pascal( )
end type

type B extends A
end type
