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
	declare function Twice( ) as long
	declare sub Bump( byval n as long )
end type

function Inner.Twice( ) as long
	return this.v * 2
end function

sub Inner.Bump( byval n as long )
	this.v += n
end sub

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

'' A METHOD CALLED THROUGH THE ARROW takes the operator's result as its RECEIVER, not
'' the handle. Measured: 'vr = _ZptR6HOLDER( &H )' and then '_ZN5INNER4BUMPEi( vr, 3 )'.
'' Check resolves the method in the arrow's result type, so the CALLEE was already
'' right; the receiver was the HANDLE, so every method called through a smart pointer
'' ran against the wrong object -- with the mangled name saying the method was found.
h->Bump( 3 )
print h->Twice( )
