'' A USER 'operator *' THAT RETURNS BY VALUE IS THE VALUE, not an address.
''
'' LowerAddr calls the operator and hands its result back AS AN ADDRESS, which is right
'' for the BYREF form that fb/sharedptr.bi and fb/comptr.bi declare -- the load around it
'' then reaches the object. A BY-VALUE operator returns the thing itself, and loading
'' through it read memory at the integer it answered:
''
''     %t22 = call i64 @"..._8OP_DEREFdeERNS2_3FOOE"(ptr %s0)
''     %t23 = load i64, ptr %t22          <- %t22 is an i64, not a pointer
''
'' The two are spelled with the same token, so only the operator's own result tells them
'' apart -- and BYREF-NESS IS ON THE DECLARATION NODE, not on the symbol's type. A
'' procedure's symbol carries its RESULT type, and 'byref as integer' leaves that an
'' integer, so asking the type made every BYREF operator take the by-value path and
'' print the ADDRESS. LowerCall reads NF_BYREF off the N_PROC for the same question.
''
'' fbc REFUSES a member 'operator *' ("Operator cannot be a member function"), which is
'' why both forms here are global.
type foo
	as integer v
end type
'' BY VALUE -- the result IS the value.
operator * ( byref lhs as foo ) as integer
	return lhs.v + 1
end operator

type bar
	as integer ptr p
end type
'' BYREF -- the result is an address, and '*b' names the object it points at.
operator * ( byref lhs as bar ) byref as integer
	return *lhs.p
end operator

dim as foo f
f.v = 41
print *f

dim as integer target_ = 7
dim as bar b
b.p = @target_
print *b
*b = 99
print target_
