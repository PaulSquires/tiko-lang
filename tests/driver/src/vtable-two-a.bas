'' Module one of the pair. It defines the methods; both modules use the types, so
'' both emit the tables. They must be module-local, as fbc emits them, or the link
'' fails on a duplicate symbol. 'is' across the two still works: fb_IsTypeOf
'' compares the RTTI ID strings, not the records' addresses.
#include once "vtable-two.bi"

function B.f( ) as long
    return 1
end function

function D.f( ) as long
    return 2
end function

dim as B x
dim as D y
print x.f( ), y.f( )
other( y )
other( x )
dim as B ptr p = makeD( )
print p->f( ), (*p is D)
