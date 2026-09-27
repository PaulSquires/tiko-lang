'' A type with a constructor and a destructor, and a variable of it DECLARED here and
'' DEFINED in a.bas.
type T
    s as string
    declare constructor( )
    declare destructor( )
end type
extern g as T
declare function Made( ) as long
