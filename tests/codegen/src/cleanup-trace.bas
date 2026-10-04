type Tr
    n as integer
    declare constructor( byval k as integer )
    declare destructor( )
end type
constructor Tr( byval k as integer ) : n = k : print "+"; k; : end constructor
destructor Tr( ) : print "-"; n; : end destructor
function mk( byval k as integer ) as Tr
    return Tr( k )
end function

sub t1( )   '' goto within an IF arm
    if 1 then
        dim t as Tr = Tr( 6 )
        goto lbl3
    end if
lbl3:
    print "[lbl3]";
end sub
sub t2( )   '' sibling scopes
    scope
        dim t as Tr = Tr( 3 )
        goto lbl
    end scope
    scope
lbl:
        print "[lbl]";
    end scope
end sub
sub t3( )   '' backward goto over a dim
    dim i as integer = 0
again:
    dim t as Tr = Tr( i )
    i += 1
    if i < 3 then goto again
end sub
sub t4( )   '' with + exit sub
    with mk( 1 )
        exit sub
    end with
end sub
sub t5( )   '' defer re-registered by goto
    dim i as integer = 0
again2:
    defer print "[d" & (i + 1) & "]";
    i += 1
    if i < 3 then goto again2
end sub
t1( ) : print
t2( ) : print
t3( ) : print
t4( ) : print
t5( ) : print
