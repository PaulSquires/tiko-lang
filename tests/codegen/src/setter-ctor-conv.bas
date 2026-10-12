type V
    as long x
    as string s
    declare constructor( byval n as long )
    declare constructor( byref t as string )
    declare constructor( byref w as V )
    declare destructor( )
end type
constructor V( byval n as long ) : x = n : s = "n" & n : print "ctor"; n : end constructor
constructor V( byref t as string ) : x = len( t ) : s = t : print "sctor "; t : end constructor
constructor V( byref w as V ) : x = w.x : s = w.s : print "copy"; x : end constructor
destructor V( ) : print "dtor"; x : end destructor
type W
    as long x
    declare constructor( byval n as long )
end type
constructor W( byval n as long ) : x = n : end constructor
type Obj
    as long tag
    declare property P( byref v as V )
    declare property Q( byval i as long, byval v as V )
    declare property R( byval v as W )
    declare property Put( byval id as long, byref v as V )
    declare property Put( byval nm as wstring ptr, byref v as V )
end type
property Obj.P( byref v as V ) : print "P"; v.x; " "; v.s : end property
property Obj.Q( byval i as long, byval v as V ) : print "Q"; i; v.x; " "; v.s : end property
property Obj.R( byval v as W ) : print "R"; v.x : end property
property Obj.Put( byval id as long, byref v as V ) : print "Put id"; id; v.x : end property
property Obj.Put( byval nm as wstring ptr, byref v as V ) : dim as string n = *nm : print "Put "; n; v.x : end property
dim as Obj o
o.P = 5
o.P = "hey"
o.Q( 1 ) = 6
o.R = 7
o.Put( 2 ) = 8
o.Put( "name" ) = "abc"
print "end"
