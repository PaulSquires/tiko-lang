'' THE 'with' SUBJECT IS EVALUATED ONCE.
''
'' Resolve points every baseless '.field' inside the body at the subject's OWN NODE,
'' which makes the tree a DAG: one expression reached from as many places as there are
'' members. Left to lower itself each time, 'with( status( hFindSlot( @this ) ) )' would
'' call hFindSlot once per '.field'. That is why only an lvalue used to be accepted as a
'' subject at all -- and an ARRAY ELEMENT is spelled as a CALL, which the parser cannot
'' tell from a procedure call, so 'with status( i )' left every member baseless and the
'' whole body declined. structs/temp-var-dtors is written that way from end to end.
''
'' Both halves are here now: the subject's ADDRESS is computed ONCE into a temporary and
'' every use of the node inside the body reads that, which is what fbc emits --
''
''     struct $1S* TMP$4;
''     int32 vr = SLOT( I );
''     TMP$4 = (struct $1S*)((int64)STATUS + ((int64)vr << 4));
''     *(int32*)TMP$4 = *(int32*)TMP$4 + 1;
''     fb_PrintInt( 0, *(int32*)TMP$4, 1 );
''
'' -- one call to SLOT for two member accesses.
''
'' 'with( x )' IS THE SPELLING THE CORPUS USES and the parentheses are a NODE, kept for
'' diagnostics; the subject is normalised to what is inside them so the kind test and
'' the lowering key agree on which node the members were pointed at.
type S
	as long refcount
	as any ptr instance
end type

dim shared as S status(0 to 7)

function slot( byval n as long ) as long
	print "slot"
	return n and 7
end function

dim as long i = 3

'' A plain variable, which always worked.
dim as S one
with one
	.refcount += 1
	print .refcount
end with

'' An array element, with and without the parentheses.
with status(i)
	.refcount += 1
	print .refcount
end with

with( status(i) )
	.refcount = 5
	.instance = 0
	print .refcount
end with

'' ...and a subject with a SIDE EFFECT, which is the whole point: one call for three
'' member accesses.
with( status( slot( i ) ) )
	.refcount += 1
	.instance = @one
	print .refcount
end with

'' A TYPE LITERAL IS A SUBJECT TOO -- 'with( type<S>( ... ) )' has an address because a
'' temporary is built for it, and the same once-evaluated slot serves it.
with( type<S>( 9, 0 ) )
	print .refcount
end with
