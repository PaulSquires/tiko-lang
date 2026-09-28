'' AN EMPTY TYPE, UNION OR ENUM -- fbc's error 256 on lines 6, 9, 12, 16, 20, 23, 29, 32, 33,
'' 35 and 38 (fbc-modern 1.20), each on the 'end'. tiko accepted every one. From line 40 on,
'' each has a field -- 'extends' and a 'redim' member are fields -- and is accepted.
type T1
    declare sub M( )
end type
sub T1.M( ) : end sub
type T2
end type
type T3
    declare constructor( )
end type
constructor T3( ) : end constructor
type T4
    static as long s
end type
dim as long T4.s
type T5
    const K = 1
end type
union U1
    declare sub M( )
end union
sub U1.M( ) : end sub
type T6
    #if 0
    a as long
    #endif
end type
type T7
    union
    end union
end type
enum E1
end enum
type T8
    declare operator cast( ) as long
end type
operator T8.cast( ) as long : return 1 : end operator
type G1 extends object
    declare sub M( )
end type
sub G1.M( ) : end sub
type G2 extends G1
    declare sub N( )
end type
sub G2.N( ) : end sub
type G3
    redim a( any ) as long
end type
type G4
    union
        a as long
        b as single
    end union
end type
enum E2
    e1
end enum
print "end"
