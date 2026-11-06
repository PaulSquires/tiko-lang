'' A generic type's field initialisers (docs/tiko-properties D10). See generic-field-init-run.test.
const KK = 40
function f( ) as long
    return 9
end function
type Box( of T )
    as long n = 3
    as T v = 7
    as string s = "s"
    as double d = 1.5
    as long k = KK + 2
    as long c = f( )
    as long z = sizeof( T )
end type
dim as Box( of long ) b
print b.n; b.v; " "; b.s; b.d; b.k; b.c; b.z
dim as Box( of double ) c
print c.n; c.v; " "; c.s; c.d; c.k; c.c; c.z
dim as Box( of long ) ptr p = new Box( of long )
print p->n; p->v
delete p
dim shared as Box( of long ) g
print g.n; g.v
