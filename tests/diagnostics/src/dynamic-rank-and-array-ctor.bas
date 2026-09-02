'' A DYNAMIC ARRAY DECLARED WITH 'any' HAS A KNOWN RANK, and both a subscript and a redim
'' must write that many dimensions -- fbc error 36, measured over a variable and a field.
'' A plain 'a()' has rank 0 and takes any shape.
''
'' AN ARRAY OF A TYPE WITH NO DEFAULT CONSTRUCTOR cannot be declared without an
'' initialiser -- fbc error 183. Measured: a constructor whose parameter is merely
'' DEFAULTED does not count, and neither does one with a calling convention written on
'' it; an initialiser that constructs every element is accepted.
type T
    as integer i
    declare constructor( byval as integer )
end type
constructor T( byval i as integer )
end constructor

type Holder
    arr(any) as integer
end type

dim a1(any) as integer
dim a2(any, any) as integer
dim h as Holder
dim okInit(0 to 0) as T = { T( 5 ) }

redim a1(0 to 1)
print a1(0)
redim a2(0 to 1, 0 to 1)
print a2(0, 0)
redim h.arr(0 to 1)
print h.arr(0)

print a1(0, 0)
print a2(0)
redim a1(0 to 1, 0 to 1)
redim a2(0 to 1)
print h.arr(0, 0)
redim h.arr(0 to 1, 0 to 1)
dim badFixed(0 to 0) as T
dim badDyn() as T
redim badRedim(0 to 0) as T
