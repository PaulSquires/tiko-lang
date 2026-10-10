'' Calls each procedure of acme/gp; see gp.bas.
#import "acme/gp"
#import "std/containers"
dim as containers.Map( of string, long ) m
m.Put( "a", 1 ) : m.Put( "b", 2 )
print gp.Total( m )
dim as containers.Array( of long ) e = gp.Evens( 3 )
print e.Count( ), e[2]
dim as gp.Acc acc
acc.AddAll( e )
print acc.total
dim as gp.Box( of long ) bx = gp.MakeBox( 9 )
print bx.Get( )
print gp.Largest( of long )( e ), gp.Smallest( of long )( e )
dim as containers.Array( of double ) ds
ds.Push( 1.5 ) : ds.Push( 0.5 )
print gp.Largest( of double )( ds )
print gp.calls
