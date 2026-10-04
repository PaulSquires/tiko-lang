'' A WITH over a temporary destroys it on every way out of the body.
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
function mk( byval n as integer ) as Tr
    return Tr( n )
end function

sub viaExitSub( )
    with mk( 1 )
        if .v = 1 then exit sub
    end with
end sub
sub viaExitFor( )
    for i as integer = 1 to 2
        with mk( 10 + i )
            if .v = 11 then continue for
            exit for
        end with
    next
    print "[x]";
end sub
sub viaGoto( )
    with mk( 3 )
        if .v = 3 then goto out_
    end with
out_:
    print "[l]";
end sub
sub nestedWith( )
    with mk( 4 )
        with mk( 5 )
            if .v = 5 then exit sub
        end with
    end with
end sub
viaExitSub( ) : print
viaExitFor( ) : print
viaGoto( ) : print
nestedWith( ) : print
