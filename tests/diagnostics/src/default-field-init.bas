'' A field with a default value gives the type an implicit constructor, and a parenthesised
'' list cannot fill it: fbc's 24 at line 14 and 7 at lines 15, 16 and 18 (fbc-modern 1.20,
'' 2026-10-25). A type without defaults takes one (line 17); '= any' counts as a default (18).
type R
    a as long
    b as long = 9
end type
type S
    a as long
    b as long
end type
type N : r as R : z as long : end type
type A2 : a as long : b as long = any : end type
dim as R r1 = ( 5 )
dim as R r2 = ( 5, 6 )
dim as N n1 = ( ( 1, 2 ), 3 )
dim as S s1 = ( 5 )
dim as A2 a1 = ( 1, 2 )
