'' 'dim as UDT x = ( 1, 2, 3 )' -- THE PAREN INITIALISER LIST.
''
'' Measured, and none of the shape is what symmetry would suggest:
''
''   - A LOCAL NEVER GETS A STATIC AGGREGATE INITIALISER. fbc declares the struct
''     uninitialised and emits one store per supplied value. The static form
''     ('static T X = { 1, 2, 3 }') comes from the STORAGE CLASS -- 'dim shared' or
''     'static' -- never from the initialiser syntax, and a module-level 'dim' is a
''     local of the module constructor that behaves exactly like one in a SUB.
''   - THE VALUES ARE FLATTENED. 'dim as Outer o = ( 1, 2, 3 )' over a type whose first
''     field is itself a UDT emits the same three stores at 0, 4 and 8 that a flat type
''     would. Nesting exists in the parser and nowhere else.
''   - A PARTIAL LIST ZEROES THE TAIL, AFTER THE STORES, and only as far as it goes:
''     'memset( &X + 4, 0, 8 )' -- addressed at the first field with no value. Not a
''     leading memset of the whole object, which is what a reader would guess.
''   - A UNION GETS NO MEMSET AT ALL. The one place the two shapes disagree.
''
'' Two node kinds arrive here: N_TUPLE when a comma was written, N_PAREN when a single
'' value was. '{ }' is NOT an alternative spelling -- fbc answers 'error 63: Expected
'' array' for a scalar UDT, so braces are exclusively the array form.
''
'' NOT HANDLED, because fbc REJECTS it outright: a UDT with a 'string' or 'string * N'
'' field cannot be initialised this way at all ('error 24: Invalid data types', or
'' 'error 7' at the first comma). A 'zstring * N' field IS allowed.

type U
    a as long
    b as long
    c as long
end type

type Inner
    p as long
    q as long
end type

type Outer
    i as Inner
    r as long
end type

union UN
    a as long
    b as short
end union

sub P( )
    dim as U x = ( 1, 2, 3 )      '' three stores, no memset
    dim as U y = ( 1 )            '' one store, then memset( base + 4, 0, 8 )
    dim as Outer o = ( 1, 2, 3 )  '' flattened: 0, 4, 8
    dim as UN u = ( 1 )           '' one store, NO memset
end sub
