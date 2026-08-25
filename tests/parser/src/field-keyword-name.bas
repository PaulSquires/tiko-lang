'' A FIELD NAME MAY BE ALMOST ANY KEYWORD. Measured against fbc one keyword at a time
'' over all 247 of them: it accepts 223 and rejects exactly twenty-four -- the operator
'' words, the declarers, and AS, DELETE, NEW and REM.
type IShell
    dummy as long
end type
type IShellVtbl
    NameSpace as function( byval This as IShell ptr, byval a as long ) as long
    Open as function( byval This as IShell ptr, byval a as long ) as long
    Explore as function( byval This as IShell ptr, byval a as long ) as long
    Windows as function( byval This as IShell ptr, byval a as long ) as long
    Print as long
    If as long
    For as long
    Type as long
    Union as long
    Property as long
    Line( 0 to 3 ) as long
end type
