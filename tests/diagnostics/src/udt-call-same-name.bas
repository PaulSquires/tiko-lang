'' See tests/diagnostics/udt-call-same-name.test.
type U
    v as long
end type
dim u as U

dim w as U = U( 3 )
u = U( 3 )
print U( 3 ).v
dim w2 as U = U( )

'' legal: an ARRAY of the type's name is subscripted
type V
    v as long
end type
dim v( 0 to 4 ) as V
v( 3 ).v = 7
print V( 3 ).v
