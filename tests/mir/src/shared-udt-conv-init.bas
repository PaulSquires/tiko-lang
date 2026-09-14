'' 'dim shared as U g = "abcd"' IS A VALUE FOR A CONVERTING CONSTRUCTOR. Only a CALL was
'' recorded for the module initialiser, so the global was default-constructed and the value
'' dropped -- tracks' 'dim shared as DWSTRING wszIconLargeDot = ...' was empty and every grid
'' dot vanished. Measured, fbc-modern prints ' 4'.
type U
    as long n
    declare constructor( byref s as string )
end type
constructor U( byref s as string )
    this.n = len( s )
end constructor
dim shared as U gU = "abcd"
print gU.n
