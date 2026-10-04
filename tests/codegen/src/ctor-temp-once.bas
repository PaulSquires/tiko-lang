'' A constructor call passed BYVAL, and one in an array's brace initialiser, is built
'' once, in place, and destroyed once. The type frees in its destructor and has no copy
'' constructor, so a second object over the same buffer is a double free.
type Obj
    as string s
    as any ptr buf
    declare constructor( )
    declare constructor( byref t as string )
    declare constructor( byval v as integer )
    declare destructor( )
end type
constructor Obj( )
    s = "default" : buf = allocate( 64 )
    print "ctor()"
end constructor
constructor Obj( byref t as string )
    s = t : buf = allocate( 64 )
    print "ctor(" & t & ")"
end constructor
constructor Obj( byval v as integer )
    s = "n" & v : buf = allocate( 64 )
    print "ctor" & v
end constructor
destructor Obj( )
    print "dtor " & s
    deallocate( buf )
end destructor
sub takeo( byval o as Obj )
    print "in takeo " & o.s
end sub
takeo( Obj( 1 ) )
print "after1"
takeo( type<Obj>( 2 ) )
print "after2"
for i as integer = 1 to 2
    dim arr( 2 ) as Obj = { Obj( "a" ), Obj( "b" ) }
    print "built " & arr( 0 ).s & arr( 1 ).s & arr( 2 ).s
next
print "end"
