'' A PROPERTY RETURNING A UDT, handed to a 'byref' parameter -- here a copy constructor's.
'' tiko passed the getter's code address as the object; fbc calls the getter. fbc 1.10.1
'' prints 205 (the getter's return copies, then the constructor copies) and 7.
type N
    as long v
    declare constructor( )
    declare constructor( byref o as const N )
end type
constructor N( )
    v = 1
end constructor
constructor N( byref o as const N )
    v = o.v + 100
end constructor
type F
    as N inner_
    declare property inner( ) as N
end type
property F.inner( ) as N
    return inner_
end property
dim as F fr
fr.inner_.v = 5
dim as N c = N( fr.inner )
print c.v
type P
    as long a
end type
type G
    as P p_
    declare property pod( ) as P
end type
property G.pod( ) as P
    return p_
end property
sub ShowP( byref p as const P )
    print p.a
end sub
dim as G gr
gr.p_.a = 7
ShowP( gr.pod )
