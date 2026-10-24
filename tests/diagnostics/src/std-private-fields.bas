'' A std container's fields are private: writing one bypassed every invariant the type keeps.
#import "std/containers"
#import "std/outcome"
dim a as containers.Array( of long )
a.num = 50
dim r as outcome.Result( of long, string ) = outcome.Ok( of long, string )( 1 )
r.ok = false
print a.Count( ), a.Data( ) = 0
