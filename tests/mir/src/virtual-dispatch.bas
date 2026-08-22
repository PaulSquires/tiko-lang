'' Virtual dispatch, and the tables it goes through. Every shape here was compared
'' against the C fbc generates for this same source.
''
''   the vtable      { null, &RTTI, slot 0, slot 1, ... }
''   the RTTI record { null, "1A", &base RTTI }   -- ID is the MANGLED name
''   the stored vptr THE TABLE PLUS TWO WORDS, at offset 0 of the object
''   a call          load the vptr, add slot * sizeof(ptr), load, call through it
type A extends object
    declare virtual function f( ) as long
    declare constructor( )
    declare virtual destructor( )
end type
function A.f( ) as long : return 1 : end function
constructor A( ) : end constructor
destructor A( ) : end destructor

'' KNOWN DIFFERENCE FROM FBC, stated rather than hidden: B declares no destructor, and
'' fbc SYNTHESISES one -- so fbc's table for B holds '_ZN1BD1Ev' in the destructor slot
'' where this one holds the inherited '_ZN1AD1Ev'. fbx synthesises no structors at all,
'' and inventing one only for this slot would be inventing half the feature. It matters
'' for a derived type that owns something needing release.
type B extends A
    declare function f( ) as long override
    declare sub callsBase( )
    declare constructor( )
end type
function B.f( ) as long : return 2 : end function
constructor B( ) : end constructor

'' 'base.f( )' IS NEVER VIRTUAL. It is the one spelling that means "the base's version
'' of this, whatever I am", and dispatching it through the vptr makes this method call
'' ITSELF, forever. fbc emits a direct '_ZN1A1FEv( (struct $1A*)THIS$1 )'.
''
'' An UNQUALIFIED call to a sibling virtual -- a bare 'f( )' here -- is the opposite: it
'' goes through this's own vptr, so in a C extends B it would reach C's f. Both measured.
sub B.callsBase( )
    dim as long r = base.f( )
    r = f( )
end sub

'' A type with a table and NO constructor: the vptr store goes at the DIM instead,
'' because fbx synthesises no constructors.
type C extends object
    declare virtual sub g( )
end type
sub C.g( ) : end sub

dim as B bb
dim as C cc
'' Through a BASE pointer holding a DERIVED object: the name binds to A.f and the call
'' must reach B.f. Emitting 'call _ZN1A1FEv' here links, verifies and returns 1.
dim as A ptr pa = @bb
print pa->f( )
cc.g( )
