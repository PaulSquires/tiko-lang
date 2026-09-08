'' 'x.v = 1' OVER A PROPERTY IS A CALL, and it was a STORE THROUGH THE GETTER'S OWN
'' CODE ADDRESS. A getter and a setter share one symbol chain; the chain is singly
'' linked and a name maps to the FIRST of its overloads, so a walk that starts at
'' whatever Resolve bound can only ever see the accessors declared after it. Resolve
'' bound 'x.v' to the getter -- the second of the two -- and the search for a setter
'' found nothing behind it, so the assignment fell through to the ordinary store path.
''
'' It VERIFIED: a store of an i64 through a pointer is well formed, and nothing there
'' knew the pointer was a function. The program wrote 1 into its own text segment.
''
'' Measured against fbc, which prints '1 1' for the plain form and '0 1 1' for the
'' aliased one below.
type UDT
    as integer p_v
    declare property v( byval new_v as integer )
    declare property v( ) as integer
end type

property UDT.v( byval new_v as integer )
    p_v = new_v
end property

property UDT.v( ) as integer
    property = p_v
end property

'' THE ALIASED FORM, which is structs/obj_property_alias.bas: the property aliases a
'' method that is also declared under that name, so the two are ONE emitted symbol.
type Aliased
    as integer p_v
    declare sub      setv alias "setv"( byval new_v as integer )
    declare property v    alias "setv"( byval new_v as integer )
    declare function getv alias "getv"( ) as integer
    declare property v    alias "getv"( ) as integer
end type

function Aliased.getv( ) as integer
    function = p_v
end function

sub Aliased.setv( byval new_v as integer )
    p_v = new_v
end sub

dim as UDT x
x.v = 1
print x.p_v, x.v

dim as Aliased a
a.p_v = 0
print a.p_v
a.v = 1
print a.p_v, a.v
