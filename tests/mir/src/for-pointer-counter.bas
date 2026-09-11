'' A POINTER COUNTER STEPS WITH M_PTR_ADD, AND THE STEP IS SCALED BY THE POINTEE.
''
'' 'for p as short ptr = f to l' advanced with a plain add over two pointers --
'' 'add ptr %t70, inttoptr (i64 1 to ptr)' -- which is not an LLVM instruction, so the
'' module was refused. That is the same fault the binary operator had before 7b.
''
'' AND FIXING ONLY THAT IS A MISCOMPILE. M_PTR_ADD takes a BYTE offset while the step is
'' in ELEMENTS, so the loop then walked one byte at a time and printed
''
''     10 5120 20 7680 30 10240 40 12800 50 15360 60
''
'' -- every value and the half of the next one -- where fbc prints 10 20 30 40 50 60.
'' It built, it verified, and it was wrong; only running it says so.
dim as short a(0 to 5) = { 10, 20, 30, 40, 50, 60 }
dim as short ptr first_ = @a(0)
dim as short ptr last_ = @a(5)
for p as short ptr = first_ to last_
	print *p;
next
print
for p as short ptr = last_ to first_ step -1
	print *p;
next
print
for p as short ptr = first_ to last_ step 2
	print *p;
next
print
