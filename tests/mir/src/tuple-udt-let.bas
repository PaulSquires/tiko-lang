'' A TUPLE ELEMENT OF A TYPE THAT EXTENDS 'wstring', and one converted by the element's
'' 'operator let'. fbc-modern 1.20 prints "S1: 1 true" and "S2: 60 true" for this
'' (measured 2026-09-25). tiko dropped both initialisers -- "2 statements not lowered"
'' -- and printed -1 false twice: the 'wstring' BASE failed the field flatten, and a
'' value of another type was stored into the element's first field instead of going
'' through its 'let'. fbx's DVARIANT is both, which is how 'return ( wszKLID, bRes )'
'' out of a function 'as (DVARIANT, BOOLEAN)' came back empty.
type V extends wstring
    as long n
    declare constructor( )
    declare constructor( byval x as long )
    declare constructor( byref o as V )
    declare destructor( )
    declare operator let( byval x as long )
end type
constructor V( ) : n = -1 : end constructor
constructor V( byval x as long ) : n = x : end constructor
constructor V( byref o as V ) : n = o.n : end constructor
destructor V( ) : end destructor
operator V.let( byval x as long ) : n = x * 10 : end operator
dim as (V, boolean) t1 = (V( 1 ), true)
print "S1:"; t1._1.n; " "; t1._2
dim as long k = 6
dim as (V, boolean) t2 = (k, true)
print "S2:"; t2._1.n; " "; t2._2
