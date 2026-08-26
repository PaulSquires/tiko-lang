'' 'varptr( x )' IS '@x', for every shape of x.
''
'' It had NO LOWERING AT ALL -- parsed, typed, and then nothing -- so every use
'' declined, including 'p = varptr( i )' over a plain local. Twenty-four uses across ten
'' corpus files.
''
'' Measured from fbc's C:
''
''     varptr( i )      (void*)&I$0                     a scalar
''     varptr( s )      (void*)&S$0                     a var-length STRING's DESCRIPTOR
''     varptr( z )      (void*)Z$0                      a 'zstring * N' is its own bytes
''     varptr( t )      (void*)&T$0
''     varptr( t.f )    (void*)&T$0                     the field at offset 0
''     varptr( a( 1 ) ) (void*)((int64)(int64*)A$0 + 8ll)
''
'' -- LowerAddr's answer in every case.
''
'' NOT sadd: measured, 'sadd( s )' is '*(char**)&S$0', the string's DATA pointer, where
'' 'varptr( s )' is '&S$0', its descriptor's address. Two different answers.

type T
	f as integer
	g as integer
end type

dim i as integer
dim s as string
dim z as zstring * 8
dim t as T
dim a( 0 to 2 ) as integer
dim p as any ptr

p = varptr( i )
print p = @i
p = varptr( s )
print p = @s
p = varptr( z )
print p = @z
p = varptr( t )
print p = @t
p = varptr( t.g )
print p = @t.g
p = varptr( a( 1 ) )
print p = @a( 1 )
