type A
	union
		type
			as short a
			as byte b
		end type
	end union
	as byte c
end type
print sizeof(A), offsetof(A, c)
type B
	union
		type
			as longint a
			as long b
		end type
	end union
	as long c
end type
print sizeof(B), offsetof(B, c)
type C
	as byte x
	union
		as short s
		as byte t
	end union
	as byte d
end type
print sizeof(C), offsetof(C, s), offsetof(C, d)
