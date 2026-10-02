'' The bottom of the diamond. Its initialisation in its three stages -- a global's
'' constructor, top-level code, a 'constructor' sub -- and its finalisation reversed.
#module "d"
'' Public: the public 'g' is one, and an importer must be able to name its type (TKO0868).
public type Loud
    s as string
    declare constructor( byref x as string )
    declare destructor( )
end type
constructor Loud( byref x as string )
    s = x
    print "D:global"
end constructor
destructor Loud( )
    print "~D:global"
end destructor
public dim shared g as Loud = Loud( "d" )
sub Ready( ) constructor
    print "D:ctor"
end sub
sub Gone( ) destructor
    print "~D:dtor"
end sub
print "D:top"
public function Name_( ) as string
    return g.s
end function
