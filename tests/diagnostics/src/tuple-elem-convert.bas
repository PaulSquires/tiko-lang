'' A TUPLE ELEMENT THAT CANNOT TAKE ITS VALUE -- fbc's errors 24 (a declaration) and 181
'' (an assignment, a 'return'). fbc-modern 1.20 refuses exactly the lines marked X and
'' accepts the rest (measured 2026-09-25); tiko accepted them all and stored the value's
'' bytes into the element. See symbols/tupleconv.bas.
type V
    as long n
    declare constructor( )
    declare constructor( byval x as long )
end type
constructor V( ) : n = 0 : end constructor
constructor V( byval x as long ) : n = x : end constructor
type D extends V
    as long m
end type
type L
    as long n
    declare operator let( byval x as long )
end type
operator L.let( byval x as long ) : n = x : end operator
type W
    as long q
end type
dim as long k = 6
dim as string s = "ab"
dim as D dd
dim as (V, boolean) a1 = (k, true)          ' X a constructor from long is not a 'let'
dim as (V, boolean) a2 = (dd, true)         ' a derived value
dim as (L, boolean) a3 = (k, true)          ' L's let takes a long
dim as (L, boolean) a4 = (2.5, true)        ' ...and a double
dim as (L, boolean) a5 = (s, true)          ' X but not a string
dim as (W, boolean) a6 = (k, true)          ' W needs no constructing
dim as (string, long) a7 = (5, 1)           ' X a number is not a string
dim as (long, long) a8 = (s, 1)             ' X nor a string a number
dim as ((V, long), long) a9 = ((k, 1), 2)   ' X nested
dim as (L, boolean) b1
b1 = (s, true)                              ' X
b1 = (k, true)
