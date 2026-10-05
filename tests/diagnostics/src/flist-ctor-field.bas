'' A PARENTHESISED LIST OVER A TYPE WITH A CONSTRUCTOR-BEARING FIELD. Measured on fbc-modern:
'' H and H2 hold a T with constructors, so lines 27-29 are errors 7, 24 and 7; H3 and H7 (a
'' plain nest) take lists, lines 30-31.
type T
    as long v
    declare constructor( )
    declare constructor( byval n as long )
end type
constructor T( ) : end constructor
constructor T( byval n as long ) : v = n : end constructor
type H
    as T inner
    as long z
end type
type H2
    as long z
    as T inner
end type
type H3
    as long a
    as long b
end type
type H7
    as H3 q
    as long w
end type
dim as H ha = ( 7, 1 )
dim as H hb = ( 7 )
dim as H2 hc = ( 7, 1 )
dim as H3 hd = ( 1, 2 )
dim as H7 he = ( 1, 2 )
