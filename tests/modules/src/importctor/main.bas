#import "./cm"
#import "std/containers"
dim a as containers.Array( of cm.TT )
a.Push( cm.TT( ) )
a.Reserve( 8 )
print a.Count( ); a[0].k; a.Pop( ).k
