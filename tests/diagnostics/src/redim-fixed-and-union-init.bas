'' ONLY A VAR-LEN ARRAY CAN BE REDIMENSIONED -- fbc error 54 for a fixed-size variable, a
'' fixed-size field (bare inside a method, through 'this', through the WITH shorthand),
'' and for an EXPRESSION in the target slot -- '( 1 )', '( a + b )', '( *pi )' -- that is
'' no array at all. A UNION IS INITIALISED WITH ONE VALUE, NOT A GROUP -- error 7 for any
'' nested parenthesised group, whatever the union holds.
type UDT
    fixedArr(0 to 1) as integer
    dynArr(any) as integer
    declare sub f( )
end type
sub UDT.f( )
    redim dynArr(0 to 1)
end sub
union U
    a as integer
    b as integer
end union
dim dyn() as integer
dim fixed_(0 to 1) as integer
dim x as UDT
dim i as integer
dim pi as integer ptr = @i
redim dyn(0 to 3)
redim x.dynArr(0 to 3)
dim as U okU = ( 1 )

redim fixed_(0 to 3)
redim x.fixedArr(0 to 3)
redim (1)(0 to 0) as integer
redim (i + 1)(0 to 0) as integer
redim (*pi)(0 to 0) as integer
dim as U bad1 = ( ( 1, 2 ) )
dim as U bad2 = ( 1, ( 2, 3 ) )
