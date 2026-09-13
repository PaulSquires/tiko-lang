'' A VALUE MAY NOT TAKE THE NAME OF A TYPE WITH MEMBERS -- see symbols/collectdecl.bas.
'' Each REFUSED line is refused by fbc-modern; everything else it compiles. The names are
'' distinct so that every refusal has exactly one cause.

type WS
    buf as wstring * 8
end type

'' ------------------------------------------------------------------------- refused
type C1
    x as integer
    declare sub m( )
end type
sub C1.m( )
    dim as integer c1 = 1                   '' accepted: the type's own method
end sub
dim as WS c1                                '' REFUSED

type C2
    x as integer
    declare constructor( )
end type
const c2 = 2                                '' REFUSED

type C3 extends object
    x as integer
end type
var c3 = 3                                  '' REFUSED

type B4
    y as integer
end type
type C4 extends B4
    x as integer
end type
redim as integer c4( 2 )                    '' REFUSED

type C5
    const K = 5
    x as integer
end type
dim shared as integer c5                    '' REFUSED

type C6
    x as integer
    declare operator let( byval v as integer )
end type
sub s6( )
    scope
        dim as integer c6                   '' REFUSED
    end scope
end sub

type C7
    x as integer
    declare property p( ) as integer
end type
sub s7( byval c7 as integer )               '' REFUSED
end sub

type C8
    x as integer
    static s as integer
end type
dim as integer c8                           '' REFUSED -- fbc's error 120

type C9
    x as integer
    enum K9
        k9a
    end enum
end type
for c9 as integer = 1 to 2                  '' REFUSED
next

namespace N10
    type C10
        x as integer
        declare sub m( )
    end type
    sub s10( )
        dim as integer c10                  '' REFUSED
    end sub
end namespace

'' ------------------------------------------------------------------------ accepted
type D                                      '' plain data may share its name
    x as integer
end type
dim as integer d

type P
private:
    x as integer
end type
dim as integer p

dim as integer v1                           '' the value FIRST
type V1
    x as integer
    declare sub m( )
end type

type O
    y as integer
    declare sub n( byval c1 as integer )
end type
sub O.n( byval c1 as integer )              '' another type's method
end sub

declare sub s11( byval c1 as integer )      '' a DECLARE's parameter

namespace M
    dim as integer c1                       '' across a namespace boundary
end namespace
dim as integer c10                          '' N10.C10 is not visible here

type CA as C1
dim as integer ca                           '' an alias is not asked

type F
    f as integer                            '' a field
    declare sub m( )
end type

type G(of T)                                '' a generic
    v as T
    declare sub m( )
end type
dim as integer g
