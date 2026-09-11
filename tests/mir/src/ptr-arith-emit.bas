'' POINTER PLUS INTEGER IS AN LLVM getelementptr, NOT AN 'add'.
''
'' The binary path widened both operands to the WIDER type, which for a pointer operand
'' is MT_PTR, so the integer was bitcast to a pointer and the two were added AS
'' POINTERS:
''
''     %t16 = add ptr %t12, %t15
''
'' That is not an instruction, and clang refused the module. 'print *(p + 1)' over ANY
'' pointer at all -- constant or variable offset, any integer width, either operand
'' order -- could not be emitted. The compound form 'p += n' had the same fault one
'' 'mul ptr' earlier.
''
'' WHAT KEPT IT HIDDEN: 'p[ i ]' takes the INDEX path, which emits M_PTR_ADD properly,
'' and that is how the corpus and the runtime headers spell a pointer walk almost
'' everywhere. tests/mir/pointer-arith and tests/mir/ptr-scale-compound both held the
'' 'add ptr' form in their goldens as expected output; neither had ever been built.
''
'' Every line below is differenced against fbc.
dim as short s(0 to 7)
for i as long = 0 to 7
	s(i) = i * 10
next
dim as short ptr p = @s(0)
dim as long n = 3
print *(p + n), *(p + 3), *(3 + p)
dim as short ptr q = p + 5
print *q, *(q - 2), *(q - n)
dim as ubyte ptr bp_ = cptr( ubyte ptr, p )
print *(bp_ + 2)
dim as any ptr ap = cptr( any ptr, cptr( ubyte ptr, p ) + 4 )
print *cptr( short ptr, ap )
print cast( longint, q ) - cast( longint, p ), q - p

'' ...and the compound form, which had the same fault one instruction earlier.
dim as short ptr w = @s(0)
w += 2
print *w
w -= 1
print *w
dim as any ptr ay = @s(0)
ay += 3
print *cptr( ubyte ptr, ay )
