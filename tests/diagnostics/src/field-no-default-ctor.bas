'' A field of a type with constructors but no default one -- fbc's error 183 on lines 12, 15
'' and 17 (fbc-modern 1.20); tiko puts the generic's at its field, line 19. Lines 24 and 25
'' are accepted: an initialiser and a pointer.
type NDC
    as long a
    declare constructor( byval n as long )
end type
constructor NDC( byval n as long )
    this.a = n
end constructor
type W1
    as NDC f
end type
type W2
    as NDC arr( 1 )
end type
type Box( of T )
    as long pad
    as T v
end type
dim as Box( of NDC ) bx

type W3
    as NDC g = NDC( 1 )
    as NDC ptr p
end type
