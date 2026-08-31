'' fbc error 67, "Too many expressions". Too FEW is legal and fills the rest with zero;
'' only too many is refused. Measured:
''
''     type of 2 fields   ( 1, 2 )       accepted
''                        ( 1, 2, 3 )    error 67
''                        ( 1 )          accepted
''     union of 2         ( 1 )          accepted
''                        ( 1, 2 )       error 67
''
'' WHAT IS COUNTED IS SCALAR LEAVES. A TYPE is the SUM over its top-level members; a
'' UNION is its FIRST member alone; a UDT member contributes ITS OWN count, not one --
'' so 'type T { a; i as Inner }' over a two-field Inner takes THREE. 'extends' needs no
'' code, because fbc spells the base as a FIELD NAMED 'base' and it flattens like any
'' other UDT member. A METHOD AND A STATIC FIELD are not slots.
''
'' AND THE TYPE COUNTED IS THE LITERAL'S: 'dim as parent p = type<child>( 4, 5 )' is
'' legal over a one-field parent -- the expressions fill a CHILD, which is then upcast.
''
'' An ARRAY or STRING member is DECLINED rather than guessed: neither has a legal flat
'' spelling at all (fbc answers error 64 and error 7), so nothing is checked there.
type Pair
    a as integer
    b as integer
end type

union U2
    a as integer
    b as integer
end union

type Anon
    a as integer
    union
        b as integer
        c as integer
    end union
end type

type Base_
    a as integer
end type

type Derived extends Base_
    b as integer
end type

type WithMethod
    a as integer
    declare sub f( )
    b as integer
end type

sub WithMethod.f( )
end sub

'' -- refused ------------------------------------------------------------------
dim shared as Pair       p3 = ( 1, 2, 3 )
dim shared as U2         u2 = ( 1, 2 )
dim shared as Anon       an = ( 1, 2, 3 )
dim shared as Derived    dv = ( 1, 2, 3 )
dim shared as WithMethod wm = ( 1, 2, 3 )

'' -- accepted -----------------------------------------------------------------
dim shared as Pair       p2 = ( 1, 2 )
dim shared as Pair       p1 = ( 1 )
dim shared as U2         u1 = ( 1 )
dim shared as Anon       a2 = ( 1, 2 )
dim shared as Derived    d2 = ( 1, 2 )

type Inner
    p as integer
    q as integer
end type

type Outer
    a as integer
    i as Inner
end type

union UAnon
    type
        a as integer
        b as integer
    end type
end union

union UScalarFirst
    z as integer
    type
        a as integer
        b as integer
    end type
end union

type HasString
    s as zstring * 8
    b as integer
end type

type HasArray
    a( 0 to 3 ) as integer
    b as integer
end type

'' -- refused, second round -----------------------------------------------------
dim shared as Outer         o4 = ( 1, 2, 3, 4 )
dim shared as UAnon         ua = ( 1, 2, 3 )
dim shared as UScalarFirst  us = ( 1, 2 )
dim shared as Base_         pb = type<Derived>( 1, 2, 3 )

'' -- accepted, second round ----------------------------------------------------
dim shared as Outer         o3 = ( 1, 2, 3 )
dim shared as Outer         on_ = ( 1, ( 2, 3 ) )
dim shared as UAnon         u2a = ( 1, 2 )
dim shared as UScalarFirst  u1s = ( 1 )
dim shared as Base_         bd = type<Derived>( 1, 2 )

'' A member with no flat spelling leaves the whole declaration unchecked -- fbc refuses
'' these too, but as error 64 and error 7, and inventing a count for them is not the job
'' of this check.
'' dim shared as HasString  hs = ( 1, 2, 3 )
'' dim shared as HasArray   ha = ( 1, 2, 3, 4, 5, 6 )
