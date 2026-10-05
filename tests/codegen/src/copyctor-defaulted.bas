type T
    as long v
    declare constructor( )
    declare constructor( byref r as T, byval extra as long = 0 )
    declare constructor( byval n as long )
end type
constructor T( ) : v = 0 : end constructor
constructor T( byref r as T, byval extra as long = 0 ) : v = r.v + 100 : print "[copy]"; : end constructor
constructor T( byval n as long ) : v = n : print "[conv]"; : end constructor
function gives( ) as T
    dim as T r = T( 5 )
    print "[ret]";
    return r
end function
function gives2( ) as T
    dim as T r = T( 7 )
    function = r
end function
print "[init]";
dim as T g = gives( )
print " g:"; g.v
dim as T h
h = gives( )
print " h:"; h.v
dim as T k = gives2( )
print " k:"; k.v
sub takes( byval tt as T ) : print " in:"; tt.v : end sub
dim as T a = T( 1 )
print
takes( a )
dim as T b = a
print " b:"; b.v
