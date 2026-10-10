#import "./cm"
#include once "fb/array.bi"
dim a as FB.Array( of cm.TT )
a.Push( cm.TT( ) )
a.Reserve( 8 )
print a.Count( ); a[0].k; a.Pop( ).k
