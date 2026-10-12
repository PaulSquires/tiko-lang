type V
    as long x
    as string s
    declare constructor( byval n as long )
    declare constructor( byref w as V )
    declare destructor( )
end type
constructor V( byval n as long ) : x = n : s = "n" & n : print "ctor"; n : end constructor
constructor V( byref w as V ) : x = w.x : s = w.s : print "copy"; x : end constructor
destructor V( ) : print "dtor"; x : end destructor
type W
    as long x
    declare constructor( byval n as long )
end type
constructor W( byval n as long ) : x = n : end constructor
type Obj
    as long tag
    declare property Q( byval i as long, byval v as V )
    declare property R( byval v as W )
    declare property S( byval v as V )
end type
property Obj.Q( byval i as long, byval v as V ) : print "Q"; i; v.x; " "; v.s : end property
property Obj.R( byval v as W ) : print "R"; v.x : end property
property Obj.S( byval v as V ) : v.x += 100 : print "S"; v.x : end property
dim as Obj o
dim as V vv = 7
o.Q( 1 ) = vv
dim as W ww = 8
o.R = ww
o.S = vv
print "vv"; vv.x
print "end"
