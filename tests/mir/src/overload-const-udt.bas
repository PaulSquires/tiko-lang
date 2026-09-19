'' A UDT whose CONST is added is one tier down: below every derived-to-base conversion.
type T1
    x as long
end type
type T2 extends T1
    y as long
end type
type T3 extends T2
    z as long
end type
declare sub f1 overload( byref a as const T2 )
declare sub f1( byref a as T1 )
sub f1( byref a as const T2 )
    print "f1 const T2"; a.y
end sub
sub f1( byref a as T1 )
    print "f1 T1"; a.x
end sub
declare sub f2 overload( byref a as const T3 )
declare sub f2( byref a as T2 )
sub f2( byref a as const T3 )
    print "f2 const T3"; a.z
end sub
sub f2( byref a as T2 )
    print "f2 T2"; a.y
end sub
declare sub f3 overload( byref a as const T1 )
declare sub f3( byref a as T1 )
sub f3( byref a as const T1 )
    print "f3 const T1"; a.x
end sub
sub f3( byref a as T1 )
    print "f3 T1"; a.x
end sub
declare sub f4 overload( byref a as const T2 )
declare sub f4( byref a as const T1 )
sub f4( byref a as const T2 )
    print "f4 const T2"; a.y
end sub
sub f4( byref a as const T1 )
    print "f4 const T1"; a.x
end sub
declare sub f5 overload( byval p as const T2 ptr )
declare sub f5( byval p as T1 ptr )
sub f5( byval p as const T2 ptr )
    print "f5 const T2 ptr"; p->y
end sub
sub f5( byval p as T1 ptr )
    print "f5 T1 ptr"; p->x
end sub
declare sub f6 overload( byval p as const T2 ptr )
declare sub f6( byval p as any ptr )
sub f6( byval p as const T2 ptr )
    print "f6 const T2 ptr"; p->y
end sub
sub f6( byval p as any ptr )
    print "f6 any ptr"
end sub
declare sub f7 overload( byval a as const T2 )
declare sub f7( byval a as T1 )
sub f7( byval a as const T2 )
    print "f7 const T2"; a.y
end sub
sub f7( byval a as T1 )
    print "f7 T1"; a.x
end sub
dim as T2 v2 = type( 12, 22 )
dim as T3 v3 = type( 13, 23, 33 )
dim as T1 v1 = type( 11 )
f1( v2 )
f1( v3 )
f2( v3 )
f3( v2 )
f3( v1 )
f4( v2 )
f5( @v2 )
f6( @v2 )
f7( v2 )
