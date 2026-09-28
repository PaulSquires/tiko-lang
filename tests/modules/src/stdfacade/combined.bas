'' std/strings AND std/containers in one program (RFC-0009): FB.Contains is a generic in
'' array.bi and a plain overload set in string.bi, and each facade's Contains reaches both.
#import "std/strings"
#import "std/containers"
dim as containers.Array( of long ) a
a.Push( 4 )
print strings.Contains( "tiko", "ik" ); " "; containers.Contains( of long )( a, 4 ); " "; strings.Contains( "tiko", "x" )
