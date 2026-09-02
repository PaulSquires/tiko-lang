'' A POINTER CANNOT LOSE A POINTEE'S CONST -- fbc error 181 -- and the two spellings of a
'' const pointer are different types: 'const ubyte ptr' is a writable pointer to a const
'' ubyte, while 'ubyte const ptr' is a CONST POINTER to a writable one. Copying the second
'' into a plain pointer copies an address and is legal; copying the first drops the
'' pointee's const and is not. Every line below was measured against fbc.
dim r1 as const ubyte ptr = 0
dim r2 as ubyte const ptr = 0
dim r3 as ubyte ptr = 0
dim r4 as ubyte ptr ptr = 0
dim r5 as ubyte const ptr ptr = 0
dim r6 as const any ptr = 0
dim r7 as const ubyte const ptr = 0
'' Refused: the pointee loses its const.
dim l1 as ubyte ptr = r1
dim l2 as ubyte ptr ptr = r5
dim l3 as any ptr = r1
dim l4 as byte ptr = r5
'' Accepted: a const POINTER is copied by value, and const may always be ADDED.
dim k1 as ubyte ptr = r2
dim k2 as const ubyte ptr = r3
dim k3 as ubyte const ptr = r3
dim k4 as const ubyte ptr ptr = r4
dim k5 as ubyte const ptr ptr = r4
dim k6 as const any ptr = r1
dim k7 as ubyte const ptr = r2
dim k8 as const ubyte ptr = r7
'' ...and a differing pointee TYPE alone is not this rule.
dim k9 as byte ptr = r3
dim k10 as any ptr = r3
'' The same question one line later, as an assignment.
dim a1 as ubyte ptr
dim a2 as const ubyte ptr
a1 = r1
a1 = r2
a2 = r3
'' ...and at a call, by value and by reference alike.
declare sub takesPtr( byval p as ubyte ptr )
declare sub takesConstPtr( byval p as const ubyte ptr )
declare sub takesRef( byref p as any ptr )
takesPtr( r1 )
takesPtr( r2 )
takesConstPtr( r1 )
takesRef( r3 )
dim cv as const integer = 0
declare sub takesIntPtr( byval p as integer ptr )
takesIntPtr( @cv )
