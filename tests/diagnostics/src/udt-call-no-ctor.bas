'' 'UDT( )' over a type with nothing to construct -- fbc's error 42 on the refused lines.
type DtorOnly
    i as integer
    declare destructor( )
end type
destructor DtorOnly( )
end destructor
type Plain
    i as integer
end type
type WithStr
    s as string
end type
sub test( byval x as DtorOnly = DtorOnly( ) )       '' 42
end sub
dim p as Plain = Plain( )                           '' 42
dim w as WithStr = WithStr( )                       '' fine: a string field constructs
