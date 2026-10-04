type Obj
    p as zstring ptr
    declare constructor( byref s as string )
    declare constructor( byval k as integer )
    declare constructor( )
    declare destructor( )
end type
constructor Obj( byref s as string )
    p = allocate( len( s ) + 1 ) : *p = s : print "+" & *p;
end constructor
constructor Obj( byval k as integer )
    p = allocate( 8 ) : *p = str( k ) : print "+" & *p;
end constructor
constructor Obj( )
    p = allocate( 2 ) : *p = "0" : print "+0";
end constructor
destructor Obj( )
    print "-" & *p; : deallocate( p )
end destructor
sub takeo( byref o as Obj )
    print "[" & *o.p & "]";
end sub
sub takev( byval o as Obj )
    print "<" & *o.p & ">";
end sub
function mko( byval k as integer ) as Obj
    return Obj( k )
end function
takeo( Obj( 1 ) ) : print
takeo( mko( 2 ) ) : print
scope
    dim arr( 1 ) as Obj = { Obj( "a" ), Obj( "b" ) }
    print "|";
end scope
print
scope
    dim as Obj x = Obj( 5 )
    print "|";
end scope
print
print "*" & *mko( 7 ).p
