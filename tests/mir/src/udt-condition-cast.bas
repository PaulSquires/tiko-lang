'' A UDT IN A CONDITION IS ITS 'operator cast', not its bytes.
''
'' 'if x then' over a type declaring one loaded the AGGREGATE and compared it to zero --
'' 'icmp ne [1 x i8] %t7, 0', which is not an instruction, so the module was refused.
'' An assignment, an argument and an initialiser all ask for the user conversion; the
'' CONDITION was the one place that did not.
''
'' AND A POINTER-RETURNING CAST SERVES A CONDITION TOO. UserCastToNum_ looks for a
'' NUMERIC result because its other callers need a width to convert to -- but a
'' condition only has to test the value, and a pointer tests perfectly well. The numeric
'' half of structs/bool_expr_cast lowered and the pointer half beside it did not.
type BT
	as byte a
	declare operator cast( ) as byte
end type
operator BT.cast( ) as byte
	return a
end operator
dim as BT x
x.a = -1
if x then
	print "true"
else
	print "false"
end if

'' ...and the pointer-returning half.
type PT
	as byte ptr a
	declare operator cast( ) as byte ptr
end type

operator PT.cast( ) as byte ptr
	return a
end operator

dim as PT p
p.a = 0
if p then print "ptr-true" else print "ptr-false"

dim as byte bb = 7
p.a = @bb
if p then print "ptr-true2" else print "ptr-false2"
