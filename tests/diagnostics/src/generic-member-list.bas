'' A generic member defined out of line with a type parameter list that does not match the
'' type's -- fbc's error 341 on lines 17, 19, 21 and 23 (fbc-modern 1.20). Lines 25 and 27
'' repeat the list exactly, the second in another case, and are accepted.
type Stack( of T )
    v as T
    declare sub Push( byval x as T )
    declare sub Pop( )
    declare sub Peek( )
    declare sub Clear( )
end type
type Pair( of K, V )
    k as K
    declare sub SetK( byval x as K )
    declare sub SetV( )
end type

sub Stack( of U ).Push( byval x as U )
end sub
sub Stack( of T, U ).Pop( )
end sub
sub Pair( of K ).SetK( byval x as K )
end sub
sub Pair( of V, K ).SetV( )
end sub
sub Stack( of T ).Peek( )
end sub
sub Stack( of t ).Clear( )
end sub
