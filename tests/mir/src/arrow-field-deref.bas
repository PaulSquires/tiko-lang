'' 'x->*pi' AND 'x->***pppi' -- A RUN OF DEREFERENCES BETWEEN THE ARROW AND THE MEMBER
'' NAME, which is how a POINTER field reached through an overloaded '->' is read. The
'' '*' stood where the member name belonged and the whole expression was TKO0402.
''
'' Measured, fbc: 'x->*pi' is '*(int64*)*(int64**)&TMP$2$0' -- the field of what the
'' arrow returns, dereferenced -- and 'x->***pppi' is
'' '*(int64*)*(*(*(int64****)((uint8*)&TMP$3$0 + 8ll)))'. Run, both print 123.
type UDT
	pi as integer ptr
	pppi as integer ptr ptr ptr
end type

dim shared globali as integer = 123

operator ->( byref l as UDT ) as UDT
	operator = l
end operator

dim x as UDT
dim as integer ptr a1 = @globali
dim as integer ptr ptr a2 = @a1
x.pi = @globali
x.pppi = @a2
print x->*pi
print x->***pppi

'' The plain arrow beside them, which always worked.
print x->pi = @globali
