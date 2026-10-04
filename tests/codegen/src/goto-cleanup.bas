'' Which cleanups a GOTO runs: none for a jump inside its own IF arm, the scope it leaves
'' for a jump into a sibling, and what was defined after the label for a backward jump.
type Tr
    as integer v
    declare constructor( byval n as integer )
    declare destructor( )
end type
constructor Tr( byval n as integer )
    v = n
    print "+" & v;
end constructor
destructor Tr( )
    print "-" & v;
end destructor
type Buf
    as integer ptr p
    declare constructor( )
    declare destructor( )
end type
constructor Buf( )
    p = allocate( 64 )
end constructor
destructor Buf( )
    deallocate( p )
end destructor
sub inArm( byval k as integer )
    if k then
        dim t as Tr = Tr( 6 )
        goto lbl1
        print "[skipped]";
lbl1:
        print "[lbl1]";
    end if
    print "[end]"
end sub
sub inArmStr( byval k as integer )
    if k then
        dim s as string = string( 50, "q" )
        if len( s ) > 1 then goto lbl2
        print "[skipped]";
lbl2:
        print "[lbl2 " & len( s ) & "]"
    end if
end sub
sub inArmHeap( byval k as integer )
    if k then
        dim b as Buf
        b.p[0] = k
        if k > 0 then goto lbl3
        print "[skipped]"
lbl3:
        print "val="; b.p[0]
    end if
end sub
sub sibling( )
    scope
        dim t as Tr = Tr( 3 )
        goto lbl4
    end scope
    scope
lbl4:
        print "[lbl4]";
    end scope
    print "[end]"
end sub
sub backward( )
    dim as integer n = 0
    scope
again:
        dim t as Tr = Tr( n )
        n += 1
        if n < 3 then goto again
    end scope
    print "[out]"
end sub
sub backwardDefer( )
    dim as integer n = 0
    scope
again2:
        n += 1
        defer print "[d" & n & "]";
        if n < 3 then goto again2
    end scope
    print "[out]"
end sub
inArm( 1 )
for i as integer = 1 to 2
    inArmStr( 1 )
next
for i as integer = 1 to 3
    inArmHeap( i )
next
sibling( )
backward( )
backwardDefer( )
print "survived"
