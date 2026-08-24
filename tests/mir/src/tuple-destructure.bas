'' 'let (a, b) = expr' -- TUPLE DESTRUCTURING, and 'return (a, b)' beside it.
''
'' The target is an N_TUPLE of lvalues and the value is ONE tuple, so it is not an
'' assignment of one thing to another: it is N assignments from the elements of a single
'' evaluation. LowerAddr was asked for the address of an N_TUPLE, which is not an lvalue
'' and has none, so the whole statement declined.
''
'' Measured from what fbc emits:
''
''     struct FBTUPLE2Iii vr = GIVESLL( );
''     TMP6 = vr;  TMP7 = &TMP6;
''     A = *(int32*)TMP7;
''     B = *(int32*)((uint8*)TMP7 + 4);
''
'' -- the right side ONCE, into a temporary whose address every element is read through,
'' so a CALL on the right runs once and not once per name. A string element is a runtime
'' call from one descriptor into the other.
''
'' AND A BARE TUPLE LITERAL HAS NO TYPE OF ITS OWN: 'return (20, 22)' names no type, so
'' it is built straight INTO the result slot from the function's own result type. fbc
'' builds a temporary and copies it in; this is the same object one copy earlier.
dim shared as long calls

function givesLL( ) as (long, long)
	calls += 1
	return (20, 22)
end function

function givesLS( ) as (long, string)
	return (5, "five")
end function

dim as long a, b
let (a, b) = givesLL( )
print a, b, calls

dim as long u
dim as string v
let (u, v) = givesLS( )
print u, v

'' From a VARIABLE, which has an address already and needs no temporary.
dim as (long, string) h = (1, "x")
dim as long t
dim as string l
let (t, l) = h
print t, l

'' The right side is evaluated ONCE: two names, one call.
calls = 0
dim as long c1, c2
let (c1, c2) = givesLL( )
print calls
