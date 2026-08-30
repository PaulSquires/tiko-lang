'' DIM'ING A COMMON WORKS LIKE A REDIM, which is what dim/dim-common-dynamic-1.bas says
'' in its own comment and it is COMPILE_ONLY_OK. tiko reported the DIM as a duplicate.
''
'' Measured, and the rule is COMMON specifically:
''
''     common a( ) as integer : dim a( 1 to 2 ) as integer   accepted
''     dim    a( ) as integer : dim a( 1 to 2 ) as integer   error 4
''     common a( ) as integer : dim a( 1 to 2 ) as single    error 4
''
'' -- so the element types still have to agree, which is the same rule the REDIM row
'' beside it already applied.
common arr( ) as integer
dim arr( 1 to 2 ) as integer

common brr( ) as integer
redim brr( 1 to 2 ) as integer
