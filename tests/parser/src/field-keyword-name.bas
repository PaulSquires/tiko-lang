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
    '' THE BOUNDS HAVE TO REACH THE FIELD, not the slot a VARIABLE keeps them in.
    '' They went to the second one, so a keyword-named array field laid out as a
    '' SCALAR -- the dump below shows the flat bound pair a field carries, and the
    '' N_BLOCK it used to show was invisible to the layout pass.
    Line( 0 to 3 ) as long
end type
