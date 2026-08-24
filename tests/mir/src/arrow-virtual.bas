'' VIRTUAL DISPATCH AND GENERIC INFERENCE THROUGH A HANDLE -- three findings, all of
'' them silent, and all of them what fb/comptr.bi exists to do.
''
'' AN ABSTRACT SLOT HAS NO PROCEDURE SYMBOL. Its entry in the emitted table is null and
'' an override fills it, so a call to the abstract DECLARATION matched no slot at all
'' and came out as a DIRECT call to a procedure with no body. Every call through a base
'' handle to an abstract method. It is matched by its DECLARATION NODE instead.
''
'' 'p->V( )' DISPATCHES THROUGH THE ARROW'S RESULT, not the handle: the handle has no
'' vtable of its own, so the slot lookup found nothing and the call fell out of the
'' virtual path entirely.
''
'' AND THE RECEIVER IS THE OPERATOR'S RESULT, not the handle. Measured -- fbc emits
'' 'vr = _ZptR1H( &HH )' and then calls through vr's vptr. Check resolves the method in
'' the arrow's result type, so the CALLEE was already right and only the receiver was
'' wrong, which is the worst shape this can take: a mangled name that says the method
'' was found and an object that is not the one it was found on.
''
'' fbc calls the operator TWICE -- once for the receiver and once for the vptr. This
'' calls it once and uses the pointer for both, which is one fewer side effect for an
'' operator that has any; noted rather than replicated.
type IFace extends Object
	declare abstract function Poke( ) as long
end type

type Impl extends IFace
	as long v
	declare function Poke( ) as long
end type

function Impl.Poke( ) as long
	return this.v + 1
end function

type H
	as IFace ptr p
end type

operator -> ( byref h as H ) byref as IFace
	return *h.p
end operator

operator * ( byref h as H ) byref as IFace
	return *h.p
end operator

dim as Impl im
im.v = 4
dim as H hh
hh.p = @im

if hh->Poke( ) > 0 then print "arrow"
if (*hh).Poke( ) > 0 then print "deref"
print hh->Poke( )

'' ...and through a plain pointer, which is the same slot and was equally direct.
dim as IFace ptr q = @im
print q->Poke( )

'' A GENERIC PROCEDURE WHOSE TYPE ARGUMENT IS INSIDE AN INSTANTIATED PARAMETER.
'' Only a bare 'T' parameter was matched, so 'byref dst as Box( of T )' inferred
'' nothing and every call declined -- ComQI and ComQIAs are both this shape. The
'' instantiation's own type arguments are recovered from its structural name, which is
'' where they were encoded.
type Box( of T )
	as T v
end type

function Grab( of T )( byval src as any ptr, byref dst as Box( of T ) ) as long
	dst.v = 0
	return 5
end function

dim as Box( of long ) bx
dim as any ptr pv
if Grab( pv, bx ) = 5 then print "grab"
dim as long got = Grab( pv, bx )
print got, bx.v
