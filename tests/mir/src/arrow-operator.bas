'' 'operator ->' ON A UDT.
''
'' 'p->v' over a UDT is a CALL to that UDT's global 'operator ->' followed by an
'' ordinary field access on what it returns -- byref, so a pointer at the ABI.
'' Measured from what fbc emits:
''
''     h->v = 77    vr = _ZptR6HOLDER( &H )   *(int32*)vr = 77
''     h->w         vr = _ZptR6HOLDER( &H )   *(int32*)((uint8*)vr + 4)
''
'' and the operator is called AGAIN for every occurrence rather than being cached.
''
'' THE MANGLED NAME IS 'pt', which nothing in the spelling says: tiko-lang was writing
'' the VENDOR EXTENSION, '_Zv12->R6HOLDER', which is a link error against every smart
'' pointer there is. Unary 'operator *' is 'de' for the same reason -- binary '*' is
'' 'ml' -- and fb/sharedptr.bi and fb/comptr.bi declare both.
type Inner
	as long v
	as long w
end type

type Holder
	as Inner ptr p
end type

operator -> ( byref h as Holder ) byref as Inner
	return *h.p
end operator

operator * ( byref h as Holder ) byref as Inner
	return *h.p
end operator

dim as Inner i
dim as Holder h
h.p = @i

h->v = 77
h->w = 88
print h->v, h->w

'' A UDT with a field of its own keeps it: the arrow is only consulted when the base
'' has no such member.
if h->v = 77 then print "ok"
