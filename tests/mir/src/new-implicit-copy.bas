'' 'NEW T( x )' WITH x A T, AND NO COPY CONSTRUCTOR OF T's OWN, COPIES x.
''
'' The argument was dropped: the object came back calloc-zeroed, its vptr null, and the
'' first virtual call through it crashed -- the FreeBASIC manual's covariant clone( ),
'' 'new myDerived( this )'. fbc synthesises the copy constructor and calls it. A derived
'' x slices (the copy carries T's own vptr); a string field is deep-copied; a type with
'' a copy constructor of its own still gets that one. fbc prints what this file prints --
'' goldenrun executes it.
type Shape extends object
    as long id
    declare virtual function clone( ) as Shape ptr
    declare virtual function kind( ) as string
end type
function Shape.clone( ) as Shape ptr
    return new Shape( this )
end function
function Shape.kind( ) as string
    return "shape"
end function
type Circle extends Shape
    as double r
    as string label
    declare function clone( ) as Circle ptr
    declare function kind( ) as string
end type
function Circle.clone( ) as Circle ptr
    return new Circle( this )
end function
function Circle.kind( ) as string
    return "circle"
end function
type Counted
    as long v
    declare constructor( )
    declare constructor( byref o as Counted )
end type
constructor Counted( )
end constructor
constructor Counted( byref o as Counted )
    v = o.v + 1000
end constructor

dim as Circle c
c.id = 7 : c.r = 2.5 : c.label = "round"
dim as Shape ptr s = @c
dim as Shape ptr s2 = s->clone( )
dim as Circle ptr c2 = c.clone( )
print s2->kind( ), s2->id, c2->kind( ), c2->r, c2->label
c.label = "changed"
print c2->label
dim as Shape ptr sliced = new Shape( c )
print sliced->kind( ), sliced->id
dim as Counted k
k.v = 5
dim as Counted ptr kp = new Counted( k )
print kp->v
delete kp
delete sliced
delete c2
delete s2
sub inproc( byref cc as Circle )
    dim as Circle ptr p = new Circle( cc )
    print p->kind( ), p->label
    delete p
end sub
inproc( c )
