'' nomove.bas -- RFC 0018 P3, V5: a 'nomove' type is never relocated.
''
'' TIKO-ONLY: 'nomove' is a tiko extension.
''
'' Pinned registers its own address at construction and checks it at destruction, as a
'' waitable or a list node does: a relocated object would be destroyed at an address nobody
'' registered, and say so. Every automatic site P1 moves -- 'return local', 'return f( )', an
'' assignment from a temporary -- must COPY a Pinned instead (its copy constructor registers
'' the copy's own address), and a type HOLDING one is nomove too. The refusals are in
'' tests/diagnostics/move-nomove.test.

dim shared as any ptr registry( 0 to 63 )
dim shared as long nReg, bad

type Pinned nomove
    as long v
    declare constructor( )
    declare constructor( byval n as long )
    declare constructor( byref rhs as Pinned )
    declare destructor( )
end type

sub Register_( byval p as any ptr )
    registry( nReg ) = p : nReg += 1
end sub
sub Unregister_( byval p as any ptr )
    for i as long = 0 to nReg - 1
        if registry( i ) = p then registry( i ) = registry( nReg - 1 ) : nReg -= 1 : return
    next
    bad += 1
    print "  RELOCATED: destroyed at an address nobody registered"
end sub

constructor Pinned( ) : Register_( @this ) : end constructor
constructor Pinned( byval n as long ) : v = n : Register_( @this ) : end constructor
constructor Pinned( byref rhs as Pinned ) : v = rhs.v : Register_( @this ) : end constructor
destructor Pinned( ) : Unregister_( @this ) : end destructor

type Holder              '' not marked: nomove because a field is
    as Pinned p
    as long tag
end type

function MakeLocal( byval n as long ) as Pinned
    dim as Pinned r = Pinned( n )
    return r
end function

function MakeTemp( byval n as long ) as Pinned
    return MakeLocal( n + 1 )
end function

function MakeHolder( byval n as long ) as Holder
    dim as Holder h
    h.p.v = n : h.tag = n * 2
    return h
end function

sub TakeP( byval x as Pinned )
    print "  (in TakeP " & x.v & ")"
end sub

scope
    dim as Pinned a = MakeLocal( 1 )
    print "N1 return local: " & a.v
    dim as Pinned b = MakeTemp( 2 )
    print "N2 return f( ): " & b.v
    b = MakeLocal( 4 )
    print "N3 assignment from a temporary: " & b.v
    TakeP( MakeLocal( 5 ) )
    print "N4 a temporary as a byval argument (in place, not relocated)"
    dim as Holder h = MakeHolder( 6 )
    print "N5 a type holding one: " & h.p.v & " " & h.tag
end scope
print "N6 registered after scope: " & nReg & ", relocated: " & bad
