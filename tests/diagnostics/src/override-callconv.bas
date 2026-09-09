'' AN OVERRIDE'S CALLING CONVENTION -- fbc error 226. Measured on win64:
''
''     base pascal, override default    error 226
''     base pascal, override pascal     accepted
''
'' PASCAL is the one that always differs: it reverses the argument order, so it is a
'' different convention on every target.
type A extends object
    declare virtual destructor pascal( )
end type

type B extends A
    declare destructor( )
end type
