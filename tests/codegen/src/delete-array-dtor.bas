type Noisy
    n as long
    declare constructor( )
    declare destructor( )
end type
constructor Noisy( )
    print "ctor"
end constructor
destructor Noisy( )
    print "dtor"; n
end destructor
dim as Noisy ptr p = new Noisy[3]
p[0].n = 0 : p[1].n = 1 : p[2].n = 2
delete[] p
type SF
    s as string
    k as long
end type
type DO_
    k as long
    declare destructor( )
end type
destructor DO_( )
    print "d"; k
end destructor
type OP
    k as long
    declare destructor( )
    declare operator new[]( byval sz as uinteger ) as any ptr
    declare operator delete[]( byval p as any ptr )
end type
destructor OP( )
    print "od"; k
end destructor
operator OP.new[]( byval sz as uinteger ) as any ptr
    print "new[]"; sz
    return callocate( sz )
end operator
operator OP.delete[]( byval p as any ptr )
    print "delete[]"
    deallocate( p )
end operator
dim as SF ptr a = new SF[2]
a[1].s = "hi"
delete[] a
dim as DO_ ptr b = new DO_[2] { any }
b[0].k = 5 : b[1].k = 6
delete[] b
dim as OP ptr o = new OP[2]
delete[] o
dim as integer n = 0
dim as DO_ ptr z = new DO_[n]
delete[] z
print "end"
