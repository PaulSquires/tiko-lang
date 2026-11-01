' 'p->P( i ) = v' over a property with a plain getter and an indexed setter, through a
' pointer, a dereference and a byref parameter, as well as on the object.
type TT
    m as long
    declare property Opt () as long
    declare property Opt (byval a as long, byval b as long)
end type
property TT.Opt () as long
    return m
end property
property TT.Opt (byval a as long, byval b as long)
    m = m or a or b
end property

sub s (byval p as TT ptr, byref r as TT)
    r.Opt( 2 ) = 4
    (*p).Opt( 8 ) = 16
    p->Opt( 32 ) = 64
end sub

dim t as TT
t.Opt( 1 ) = 0
s( @t, t )
print t.Opt
