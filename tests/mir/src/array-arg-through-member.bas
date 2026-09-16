'' A WHOLE ARRAY PASSED THROUGH A MEMBER. 'm.arr( )' is the same spelling as 'arr( )',
'' and the callee REDIMs what it is given, so the descriptor really has to be the
'' member's own and not a copy. Measured under fbc-modern: both lines print the same
'' four numbers, and the member's array is 4 elements long afterwards.
''
'' tiko-editor's modFuzzy writes exactly this --
'' 'fuzzy_precompute_bonus( haystack, m.match_bonus( ) )' over a
'' 'match_bonus( any ) as score_t' field -- and it was the last frontend error in the
'' whole 100k-line unity build.
type Holder
    arr( any ) as long
    n as long
end type

sub fill_( a( ) as long, byval hi as long )
    redim a( hi )
    for i as long = 0 to hi
        a( i ) = i * 10
    next
end sub

dim as Holder m
dim as long plain( any )

'' The plain spelling, which always worked, so a fix that only ever takes the member
'' form cannot pass.
fill_( plain( ), 3 )
print "plain  "; plain( 0 ); plain( 1 ); plain( 2 ); plain( 3 )

fill_( m.arr( ), 3 )
print "member "; m.arr( 0 ); m.arr( 1 ); m.arr( 2 ); m.arr( 3 )
print "bounds "; lbound( m.arr ); ubound( m.arr )
