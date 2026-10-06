'' an anonymous group's own field = N caps its members and its padding; where it sits is the enclosing cap over its natural alignment
#define QWORD_ALIGN 8


		type A
			union
				type
					as short a
					as byte b
				end type
			end union
			as byte c
		end type

		type B
			union
				type
					as longint a
					as long b
				end type
			end union
			as long c
		end type

		union C
			type field = 1
				as byte a
				as long b
				as byte c
			end type
		end union

		union D field = 1
			type
				as byte a
				as long b
				as byte c
			end type
		end union

		union E field = 1
			type field = 1
				as byte a
				as long b
				as byte c
			end type
		end union

		type F
			union field = 1
				type
					as short a
					as byte b
				end type
			end union
			as byte c
		end type

		type G
			union field = 1
				type
					as short a
					as byte b
				end type
			end union
			as short c
		end type

print "A", sizeof(A), offsetof(A, c)
print "B", sizeof(B), offsetof(B, c)
print "C", sizeof(C), offsetof(C, b), offsetof(C, c)
print "D", sizeof(D), offsetof(D, b), offsetof(D, c)
print "E", sizeof(E), offsetof(E, b), offsetof(E, c)
print "F", sizeof(F), offsetof(F, b), offsetof(F, c)
