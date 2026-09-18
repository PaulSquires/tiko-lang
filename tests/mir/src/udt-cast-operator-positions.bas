'' 'operator cast( ) as <another UDT>' IS TAKEN IN EVERY POSITION THAT CONVERTS, not
'' only for a byval argument. Measured on fbc-modern, over a 56-byte Wide_ that casts
'' to a 24-byte Narrow_: an initialiser, an assignment, an explicit 'cast( )' and a
'' byref parameter all print 111 222 333, the values the operator makes.
''
'' tiko-lang took the operator for a byval argument (udt-cast-operator-byval-arg) and
'' for nothing else: the initialiser blitted the source's first 24 bytes, and the other
'' three produced 0 8 9 -- a partial copy of a type that is not theirs. The byval case
'' was the one that could overrun a frame, which is why it was fixed first; these three
'' are wrong values rather than corruption, and just as wrong.
''
'' The CONSTRUCTOR on the destination still wins where there is one, and a DERIVED value
'' is not a conversion at all -- it is the base subobject, and the ordinary copy has
'' always had that right.
''
'' THE GOLDEN IS THE ASSERTION: four calls to _ZN5WIDE_cv7NARROW_Ev, one per position.
'' The broken compiler emitted one -- the argument's -- and reached the other three
'' destinations with a bare aggregate load.

type Narrow_
    a as longint
    b as longint
    c as longint
end type

type Wide_
    p as longint
    q as longint
    r as longint
    s as longint
    t as longint
    u as longint
    v as longint
    declare operator cast( ) as Narrow_
end type

operator Wide_.cast( ) as Narrow_
    dim as Narrow_ n
    n.a = 111
    n.b = 222
    n.c = 333
    return n
end operator

sub TakeRef_( byref n as Narrow_ )
    print "byref :"; n.a; n.b; n.c
end sub

dim as Wide_ w
w.p = 7
w.q = 8
w.r = 9

dim as Narrow_ n1 = w
print "init  :"; n1.a; n1.b; n1.c

dim as Narrow_ n2
n2 = w
print "assign:"; n2.a; n2.b; n2.c

dim as Narrow_ n3 = cast( Narrow_, w )
print "cast  :"; n3.a; n3.b; n3.c

TakeRef_( w )
