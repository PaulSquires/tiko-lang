'' A STATIC ARRAY OF UDT IS A BYTE IMAGE, one element's leaf list after another. The
'' aggregate-element rejection in the fold turned every one of them away, so a static
'' table of UDT got NO initialiser bytes at all -- the size was right and the contents
'' were zero -- while a single static UDT beside it folded. Measured, fbc:
''
''     static struct $2OD ARR$[2] = { { 1, 2 }, { 3, 4 } };
''     static struct $6MYTYPE TB$0[2] = { { 1ll, 2ll, { 3, 4, 5 }, 6 }, ... };
''
'' and run it prints ' 1  2  3  4' and ' 1 4 6 2 10 12'.
type od
	as long a
	as long b
end type

dim shared as od arr(0 to 1) = { ( 1, 2 ), ( 3, 4 ) }
print arr(0).a, arr(0).b, arr(1).a, arr(1).b

'' ...with a NESTED ARRAY MEMBER, which is how the corpus writes it.
type mytype
	as integer a, b
	as short c(0 to 2)
	as byte d
end type

static shared as mytype tb(0 to 1) = { ( 1, 2, { 3, 4, 5 }, 6 ), _
                                       ( 2, 4, { 6, 8, 10 }, 12 ) }
print tb(0).a; tb(0).c(1); tb(0).d; tb(1).a; tb(1).c(2); tb(1).d

'' A FIXED-STRING array element, whose bound is an enum member -- the shape
'' optimizations/generator/math-torture.bas writes.
enum Op
	OP_ADD
	OP_SUB
	OP__COUNT
end enum

static shared as zstring * 4 optext(0 to OP__COUNT - 1) = { " + ", " - " }
print optext(0); optext(1)
